function appendData(data, filename) {
    let mainContainer = document.getElementById("tag-fuer-tag-modal-body");
    for (let i in data) {
    if (filename != data[i].filename) {

        let div = document.createElement("div");
        div.classList.add(data[i].type)
        let typebutton = document.createElement("span");
        typebutton.setAttribute("class", "badge rounded-pill");
        if (data[i].color) {
            typebutton.setAttribute("style", "color: white; background-color: " + data[i].color)
        } else {
            typebutton.setAttribute("style", "color: white; background-color: darkgrey;")
        };
        
        typebutton.innerHTML = data[i].caption;
        div.appendChild(typebutton);
        let head = document.createElement("p");
        let headlink = document.createElement("a");
        headlink.setAttribute("href", data[i].idno);
        headlink.setAttribute("target", "_blank");
        headlink.setAttribute("style", "color:" + data[i].color);
        headlink.innerHTML = data[i].head;
        head.appendChild(headlink);
        div.appendChild(head);
        mainContainer.appendChild(div);
        if (data[i].text) {
            let textP = document.createElement("p");
            textP.innerHTML = (data[i].text);
            div.appendChild(textP);
        }
        if (data[i].bibl) {
            let textP = document.createElement("p");
            textP.innerHTML = ('Quelle: ' +data[i].text);
            div.appendChild(textP);
        }
        if (data[i].desc) {
            let descUl = document.createElement("ul");
            if (data[i].desc.listPerson) {
                let personLi = document.createElement("p");
                personLi.appendChild(icon('person'));
                listperson = data[i].desc.listPerson;
                for (let j in listperson) {
                    let personButton = document.createElement("span");
                    personButton.setAttribute("class", "tage_item_span");
                    personButton.appendChild(farbirgerPunkt(data[i].color));
                    let personButtonA = document.createElement("a");
                    personButtonA.setAttribute("target", "_blank");
                    if (listperson[j].ref.includes('/gnd/')) {
                        const correspSearchURL = listperson[j].ref.slice(listperson[j].ref.indexOf('/gnd/') + 5);
                        personButtonA.setAttribute("href", 'https://correspsearch.net/de/suche.html?s=http://d-nb.info/gnd/' + correspSearchURL);
                    } else {
                        if (listperson[j].ref.startsWith('http') || listperson[j].ref.startsWith('doi')) {
                            personButtonA.setAttribute("href", listperson[j].ref);
                        } else {
                            if (listperson[j].ref.startsWith('pmb') || listperson[j].ref.startsWith('person_')) {
                                personButtonA.setAttribute("href", 'https://' + data[i].type + '.acdh.oeaw.ac.at/' + listperson[j].ref + '.html');
                            }
                        }
                    }
                    personButtonA.innerHTML = (listperson[j].persName);
                    personButton.appendChild(personButtonA);
                    personLi.appendChild(personButton);
                    descUl.appendChild(personLi);
                }
                div.appendChild(descUl)
                if (data[i].desc.listBibl) {
                    let biblLi = document.createElement("p");
                    biblLi.appendChild(icon('bibl'));
                    
                    listBibl = data[i].desc.listBibl;
                    for (let j in listBibl) {
                        let biblButton = document.createElement("span");
                        biblButton.setAttribute("class", "tage_item_span");
                        biblButton.appendChild(farbirgerPunkt(data[i].color));
                        
                        let biblButtonA = document.createElement("a");
                        biblButtonA.setAttribute("target", "_blank");
                        if (listBibl[j].ref.startsWith('pmb')) {
                            biblButtonA.setAttribute("href", 'https://' + data[i].type + '.acdh.oeaw.ac.at/' + listBibl[j].ref + '.html');
                        }
                        biblButtonA.innerHTML = (listBibl[j].title);
                        biblButton.appendChild(biblButtonA);
                        
                        biblLi.appendChild(biblButton);
                        descUl.appendChild(biblLi);
                    }
                    div.appendChild(descUl)
                }
                if (data[i].desc.listOrg) {
                    let orgLi = document.createElement("p");
                    orgLi.appendChild(icon('org'));
                    
                    listOrg = data[i].desc.listOrg;
                    for (let j in listOrg) {
                        let orgButton = document.createElement("span");
                        orgButton.setAttribute("class", "tage_item_span");
                        orgButton.appendChild(farbirgerPunkt(data[i].color));
                        
                        let orgButtonA = document.createElement("a");
                        orgButtonA.setAttribute("target", "_blank");
                        if (listOrg[j].ref.startsWith('pmb')) {
                            orgButtonA.setAttribute("href", 'https://' + data[i].type + '.acdh.oeaw.ac.at/' + listOrg[j].ref + '.html');
                        }
                        orgButtonA.innerHTML = (listOrg[j].orgName);
                        orgButton.appendChild(orgButtonA);
                        
                        orgLi.appendChild(orgButton);
                        descUl.appendChild(orgLi);
                    }
                    div.appendChild(descUl)
                }
                if (data[i].desc.listPlace) {
                    let placeLi = document.createElement("p");
                    placeLi.appendChild(icon('place'));
                    
                    listPlace = data[i].desc.listPlace;
                    for (let j in listPlace) {
                        let placeButton = document.createElement("span");
                        
                        placeButton.setAttribute("class", "tage_item_span");
                        
                        placeButton.appendChild(farbirgerPunkt(data[i].color));
                        let placeButtonA = document.createElement("a");
                        placeButtonA.setAttribute("target", "_blank");
                        if (listPlace[j].ref.startsWith('pmb')) {
                            placeButtonA.setAttribute("href", 'https://' + data[i].type + '.acdh.oeaw.ac.at/' + listPlace[j].ref + '.html');
                        }
                        
                        placeButtonA.innerHTML = (listPlace[j].placeName);
                        placeButton.appendChild(placeButtonA);
                        
                        placeLi.appendChild(placeButton);
                        descUl.appendChild(placeLi);
                    }
                    div.appendChild(descUl)
                }
            }
        }
        }
    }
}

function farbirgerPunkt(color) {
    let farbirgerPunkt = document.createElement("span");
    farbirgerPunkt.style.color = color;
    let fixesLeerzeichen = '\u{00A0}';
    farbirgerPunkt.textContent = "■" + fixesLeerzeichen;
    return (farbirgerPunkt)
}

function icon(typ) {
    let ic = document.createElement("i");
    if (typ === 'person') {
        ic.setAttribute("class", "fa-regular fa-users");
        ic.setAttribute("title", "Erwähnte Personen");
    } else {
        if (typ === 'bibl') {
            ic.setAttribute("class", "fa-regular fa-image");
            ic.setAttribute("title", "Erwähnte Werke");
        } else {
            if (typ === 'place') {
                ic.setAttribute("class", "fa-regular fa-map-location-dot");
                ic.setAttribute("title", "Erwähnte Orte");
            } else {
                if (typ === 'org') {
                    ic.setAttribute("class", "fa-regular fa-building-columns");
                    ic.setAttribute("title", "Erwähnte Institutionen");
                }
            }
        }
    };
    let leerspan = document.createElement("span");
    leerspan.textContent = '\u{00A0}\u{00A0}';
    let icon = document.createElement("span");
    icon.appendChild(ic);
    icon.appendChild(leerspan);
    return (icon)
}