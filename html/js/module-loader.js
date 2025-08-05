/**
 * Modular JavaScript loader with lazy loading and performance optimization
 * Manages script loading based on page requirements and user interactions
 */

class ModuleLoader {
    constructor() {
        this.loadedModules = new Set();
        this.loadingModules = new Map();
        this.observers = new Map();
        this.performanceMetrics = {
            modulesLoaded: 0,
            totalLoadTime: 0,
            errors: []
        };
        
        this.init();
    }
    
    init() {
        // Initialize core modules immediately
        this.loadCoreModules();
        
        // Set up intersection observers for lazy loading
        this.setupIntersectionObservers();
        
        // Set up event listeners for dynamic loading
        this.setupEventListeners();
        
        // Performance monitoring
        this.setupPerformanceMonitoring();
    }
    
    loadCoreModules() {
        // Load essential modules immediately
        const coreModules = [
            'accessibility-enhancements',
            'copytoclipboard'
        ];
        
        coreModules.forEach(module => {
            this.loadModule(module, { priority: 'high' });
        });
    }
    
    setupIntersectionObservers() {
        // Observer for lazy loading content
        this.observers.set('lazy-content', new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const module = entry.target.dataset.module;
                    if (module) {
                        this.loadModule(module);
                        this.observers.get('lazy-content').unobserve(entry.target);
                    }
                }
            });
        }, { rootMargin: '50px' }));
        
        // Observer for image lazy loading
        this.observers.set('lazy-images', new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        img.classList.add('loaded');
                        this.observers.get('lazy-images').unobserve(img);
                    }
                }
            });
        }, { rootMargin: '100px' }));
        
        // Apply observers to existing elements
        this.applyObservers();
    }
    
    applyObservers() {
        // Apply lazy content loading
        document.querySelectorAll('[data-module]').forEach(el => {
            this.observers.get('lazy-content').observe(el);
        });
        
        // Apply lazy image loading
        document.querySelectorAll('img[data-src]').forEach(img => {
            this.observers.get('lazy-images').observe(img);
        });
    }
    
    setupEventListeners() {
        // Load modules on specific user interactions
        document.addEventListener('click', (e) => {
            const target = e.target.closest('[data-load-module]');
            if (target) {
                const module = target.dataset.loadModule;
                this.loadModule(module);
            }
        });
        
        // Load modules when modals are opened
        document.addEventListener('show.bs.modal', (e) => {
            const modal = e.target;
            const module = modal.dataset.module;
            if (module) {
                this.loadModule(module);
            }
        });
        
        // Load modules based on page focus (for analytics, etc.)
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.loadModule('analytics', { priority: 'low' });
            }
        });
    }
    
    setupPerformanceMonitoring() {
        // Monitor Core Web Vitals
        if ('web-vital' in window) {
            this.monitorWebVitals();
        }
        
        // Monitor script loading performance
        this.monitorScriptPerformance();
    }
    
    async loadModule(moduleName, options = {}) {
        const { priority = 'normal', timeout = 10000 } = options;
        
        if (this.loadedModules.has(moduleName)) {
            return Promise.resolve();
        }
        
        if (this.loadingModules.has(moduleName)) {
            return this.loadingModules.get(moduleName);
        }
        
        const startTime = performance.now();
        
        const loadPromise = this.createLoadPromise(moduleName, timeout)
            .then(() => {
                this.loadedModules.add(moduleName);
                this.performanceMetrics.modulesLoaded++;
                this.performanceMetrics.totalLoadTime += performance.now() - startTime;
                
                console.log(`✓ Module '${moduleName}' loaded in ${(performance.now() - startTime).toFixed(2)}ms`);
            })
            .catch(error => {
                this.performanceMetrics.errors.push({
                    module: moduleName,
                    error: error.message,
                    timestamp: new Date().toISOString()
                });
                console.error(`✗ Failed to load module '${moduleName}':`, error);
            })
            .finally(() => {
                this.loadingModules.delete(moduleName);
            });
        
        this.loadingModules.set(moduleName, loadPromise);
        return loadPromise;
    }
    
    createLoadPromise(moduleName, timeout) {
        return new Promise((resolve, reject) => {
            const script = document.createElement('script');
            script.src = `/js/${moduleName}.js`;
            script.async = true;
            script.defer = true;
            
            const timeoutId = setTimeout(() => {
                reject(new Error(`Module '${moduleName}' loading timeout`));
            }, timeout);
            
            script.onload = () => {
                clearTimeout(timeoutId);
                resolve();
            };
            
            script.onerror = () => {
                clearTimeout(timeoutId);
                reject(new Error(`Failed to load script: ${script.src}`));
            };
            
            document.head.appendChild(script);
        });
    }
    
    preloadModule(moduleName) {
        // Preload module without executing
        const link = document.createElement('link');
        link.rel = 'preload';
        link.href = `/js/${moduleName}.js`;
        link.as = 'script';
        document.head.appendChild(link);
    }
    
    loadModuleOnIdle(moduleName) {
        // Load module when browser is idle
        if ('requestIdleCallback' in window) {
            requestIdleCallback(() => {
                this.loadModule(moduleName, { priority: 'low' });
            });
        } else {
            // Fallback for browsers without requestIdleCallback
            setTimeout(() => {
                this.loadModule(moduleName, { priority: 'low' });
            }, 2000);
        }
    }
    
    monitorWebVitals() {
        // Monitor Cumulative Layout Shift (CLS)
        let cls = 0;
        new PerformanceObserver((list) => {
            for (const entry of list.getEntries()) {
                if (!entry.hadRecentInput) {
                    cls += entry.value;
                }
            }
        }).observe({ type: 'layout-shift', buffered: true });
        
        // Monitor First Input Delay (FID)
        new PerformanceObserver((list) => {
            for (const entry of list.getEntries()) {
                console.log('FID:', entry.processingStart - entry.startTime);
            }
        }).observe({ type: 'first-input', buffered: true });
        
        // Monitor Largest Contentful Paint (LCP)
        new PerformanceObserver((list) => {
            const entries = list.getEntries();
            const lastEntry = entries[entries.length - 1];
            console.log('LCP:', lastEntry.startTime);
        }).observe({ type: 'largest-contentful-paint', buffered: true });
    }
    
    monitorScriptPerformance() {
        // Monitor script loading times
        new PerformanceObserver((list) => {
            for (const entry of list.getEntries()) {
                if (entry.name.includes('/js/') && entry.name.endsWith('.js')) {
                    console.log(`Script ${entry.name}: ${entry.duration.toFixed(2)}ms`);
                }
            }
        }).observe({ entryTypes: ['resource'] });
    }
    
    getPerformanceReport() {
        return {
            ...this.performanceMetrics,
            loadedModules: Array.from(this.loadedModules),
            averageLoadTime: this.performanceMetrics.totalLoadTime / this.performanceMetrics.modulesLoaded || 0
        };
    }
    
    // Utility methods for specific page types
    loadForLetterPage() {
        this.loadModule('prev-next-urlupdate');
        this.loadModuleOnIdle('citation-date');
        
        // Load chart modules only if needed
        if (document.querySelector('[data-chart]')) {
            this.loadModule('correspondence-networks');
        }
    }
    
    loadForCalendarPage() {
        this.loadModule('calendar');
        this.preloadModule('timeline-leaflet');
    }
    
    loadForSearchPage() {
        this.loadModule('ts_index');
        this.loadModule('ts_update_url');
    }
    
    loadForIndexPage() {
        this.loadModuleOnIdle('make_map_and_table');
        
        // Load chart modules for statistics
        if (document.querySelector('#container-ohne-slider')) {
            this.loadModule('jung-wien-charts-ohne-slider');
        }
    }
}

// Auto-detect page type and load appropriate modules
class PageDetector {
    static detect() {
        const path = window.location.pathname;
        const body = document.body;
        
        if (path.includes('calendar')) {
            return 'calendar';
        } else if (path.includes('search')) {
            return 'search';
        } else if (path.match(/L\d+\.html/)) {
            return 'letter';
        } else if (path.includes('list') || path === '/' || path === '/index.html') {
            return 'index';
        }
        
        return 'default';
    }
}

// Initialize module loader when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const moduleLoader = new ModuleLoader();
    const pageType = PageDetector.detect();
    
    // Load page-specific modules
    switch (pageType) {
        case 'letter':
            moduleLoader.loadForLetterPage();
            break;
        case 'calendar':
            moduleLoader.loadForCalendarPage();
            break;
        case 'search':
            moduleLoader.loadForSearchPage();
            break;
        case 'index':
            moduleLoader.loadForIndexPage();
            break;
    }
    
    // Make module loader globally available
    window.moduleLoader = moduleLoader;
    
    // Load non-critical modules after initial page load
    window.addEventListener('load', () => {
        moduleLoader.loadModuleOnIdle('imageLoaded');
        moduleLoader.loadModuleOnIdle('resize');
    });
    
    // Performance reporting (development only)
    if (window.location.hostname === 'localhost' || window.location.search.includes('debug=true')) {
        setTimeout(() => {
            console.log('Module Loading Performance:', moduleLoader.getPerformanceReport());
        }, 5000);
    }
});

// Service Worker registration for advanced caching
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
            .then(registration => {
                console.log('SW registered: ', registration);
            })
            .catch(registrationError => {
                console.log('SW registration failed: ', registrationError);
            });
    });
}