(function() {
    var youkufix = function() {
        var e = document.createElement("video").canPlayType("application/x-mpegURL") ? !0 : !1, t = {getTop: function(e) {
                var n = e.offsetTop;
                return e.offsetParent != null && (n += t.getTop(e.offsetParent)), n
            },getLeft: function(e) {
                var n = e.offsetLeft;
                return e.offsetParent != null && (n += t.getLeft(e.offsetParent)), n
            },byId: function(e) {
                return document.getElementById(e)
            },cTag: function(e, t, n, r) {
                var i = document.createElement(e);
                return t && (i.className = t), n && n.appendChild(i), r && (i.innerHTML = r), i
            },rNode: function(e) {
                try {
                    e.parentNode.removeChild(e)
                } catch (t) {
                }
            },dClick: function(e) {
                var t = {}, n = "d_click", r = function(n) {
                    if (!n || n == e || !n.getAttribute || !n.tagName)
                        return;
                    var i = n.getAttribute("data-click"), s;
                    if (i && t[i])
                        for (s = 0; s < t[i].length; s++)
                            t[i][s](n);
                    r(n.parentNode)
                }, i = function(e) {
                    e = e || window.event, r(e.target || e.srcElement)
                }, s = function(e, n) {
                    t[e] || (t[e] = []), t[e].push(n)
                };
                return e.onclick = i, {add: s,destroy: function() {
                        e.onclick = null
                    }}
                },callIosFun: function(e,t){
                    var u ="func://"+e;
                    if(t)u = u+"/?p="+t;
                    window.location.href = u;
                },jsonp: function(e, n, r) {
                var i = document.createElement("script"), s = r || "HTML5Player" + (new Date).getTime() + Math.random().toString().replace(".", "");
                window[s] = function() {
                    n && n.apply(this, arguments), t.rNode(i), delete window[s]
                }, document.body.appendChild(i), i.src = e + s
            }}, n = !1, r = "&#x8FBE;&#x6210;&#x5951;&#x7EA6;&#x7684;&#x8FC7;&#x7A0B;&#x4E2D;&#x597D;&#x50CF;&#x51FA;&#x73B0;&#x4E86;&#x95EE;&#x9898;", i = "youkufix-", s = t.cTag("div", i + "cover"), o = t.cTag("div", i + "layer"), u = t.cTag("div", i + "title", o, "youkufix"), a = t.cTag("div", i + "player", o), f = t.cTag("video", i + "video", a), l = t.cTag("div", i + "ctrlbar " + i + "ctrlbarhover", a), c = t.cTag("div", i + "ctrlbarbottom", l), h = t.cTag("div", i + "progressNum", c), p = t.cTag("div", i + "progress", c), d = t.cTag("div", i + "volume", c), v = t.cTag("div", i + "btns", c), hd = t.cTag("div", i + "btn", v, "&#x9AD8;&#x6E05;"), m = t.cTag("div", i + "close", l), g = t.cTag("div", i + "center", l, '<div class="' + i + 'center-before"></div><div class="' + i + 'center-after"></div>'), y = t.cTag("div", i + "range", p), b = t.cTag("div", i + "rangeinner", y), w = t.cTag("div", i + "rangebtn", b), E = t.cTag("div", i + "range", d), S = t.cTag("div", i + "rangeinner", E), x = t.cTag("div", i + "rangebtn", S), T = t.cTag("div", i + "btn " + i + "cmtBtn", v), N = t.cTag("div", i + "btn " + i + "allscreen", v),k = t.cTag("div", i + "comment"), L = t.cTag("div", i + "commentFloat", k), A = t.cTag("div", i + "commentBottom", k), O = t.cTag("div", i + "logArea");
        T.style.display = "none", m.setAttribute("data-click", "close"),  N.setAttribute("data-click", "allscreen"), g.setAttribute("data-click", "center")/*, f.setAttribute("autoplay", "true")*/, hd.setAttribute("data-click", "hd"),hd.className = i + "btn ";
        var M, _ = !1, D = !1, P = !0, H = 0, B = t.dClick(o), j = B.add, F = [], I = undefined, q = t.cTag("div"), R = {setUrl: function(e) {
                R.url = e;R.url.push("");
                f.src = R.url[0],f.play(),  R.url.push(R.url.shift());
            },addEndListener: function() {
                f.addEventListener("ended",function(){
                	if(R.url[0]!=""){
                     f.src = R.url[0],f.play(),R.url.push(R.url.shift());}
                	R.log("end")
                },!1);
            },addUrl: function(e) {
                var n, r;
                for (n in e)
                    r = t.cTag("div", i + "btn", null, n), v.insertBefore(r, v.children[0]), r.setAttribute("data-click", "hd"), r.setAttribute("data-url", e[n]), F.push(r), R.url && R.url.push(e[n])
            },setFlashElement: function(e) {
                try {
                    I = e, e.parentNode.insertBefore(q, I), e.parentNode.removeChild(I)
                } catch (t) {
                }
            },formatTime: function(e) {
                var t = parseInt(e / 3600), n = parseInt((e - t * 3600) / 60), r = parseInt((e - t * 3600 - n * 60) / 1);
                return t + ":" + n + ":" + r
            },showPlayer: function() {
                if(!document.getElementsByClassName(o.className).length){
                  document.body.appendChild(s), document.body.appendChild(o), document.body.appendChild(O), P = !1}
            },initComment: function() {
                T.style.display = "", T.setAttribute("data-click", "cmt"), T.setAttribute("data-status", "show"), T.className = i + "btn " + i + "select " + i + "cmtBtn", j("cmt", function() {
                    T.getAttribute("data-status") == "show" ? (R.hideComment(), T.className = i + "btn " + i + "cmtBtn", T.setAttribute("data-status", "hide")) : (R.showComment(), T.className = i + "btn " + i + "select " + i + "cmtBtn", T.setAttribute("data-status", "show"))
                })
            },cmt: null,commentLoop: function() {
            },hideComment: function() {
                A.innerHTML = L.innerHTML = "", R.commentLoop = function() {
                }
            },showComment: function(e) {
                if (e)
                    R.cmt = e = e.sort(function(e, t) {
                        return parseFloat(e.p[0]) - parseFloat(t.p[0])
                    });
                else {
                    if (!R.cmt)
                        return;
                    e = R.cmt
                }
                a.appendChild(k);
                var t = 0, n = 0;
                R.commentLoop = function(r) {
                    if (t === r)
                        return;
                    t > r && (t = r-1, n = 0),t + 1.5 < r && (t = r - 1.5, n = 0);
                    var i, s = [t, r], o = n;
                    while (i = e[o++]) {
                        var u = parseFloat(i.p[0]);
                        if (u < s[0])
                            continue;
                        if (u >= s[1])
                            break;
                        i.p[1] <= 3 && R.pushCmt(i.msg, i.p), (i.p[1] == 4 || i.p[1] == 5) && R.pushCmtBottom(i.msg, i.p);
                        n = o;
                    }
                    t = r;
                }
            },pushCmtBottom: function(e, n) {
                var r = 4, s = t.cTag("div", i + "commentBlockBottom");
                s.appendChild(document.createTextNode(e)), A.children[0] ? A.insertBefore(s, A.children[0]) : A.appendChild(s), s.style.cssText += ";color:#" + n[3].toString(16) + ";", setTimeout(function() {
                    s.parentNode.removeChild(s)
                }, r * 1e3)
            },line: [],pushCmt: function(e, n) {
                var r = 8, s = 0, o = 0, u = a.offsetWidth, f = t.cTag("div", i + "commentBlock");
                f.appendChild(document.createTextNode(e)), L.appendChild(f), s = f.offsetWidth + 10, o = 25, u += s, removeTime = r / a.offsetWidth * u, isShowdTime = r / a.offsetWidth * s;
                var l = 0;
                while (R.line[l])
                    l++;
                R.line[l] = f;
                f.style.cssText += ";-webkit-transform: translate3d(" + u + "px, 0, 0);top:" + l * o + "px;left:0px;color:#" + parseInt(n[3]).toString(16) + ";";
                setTimeout(function() {
                    f.style.cssText += ";-webkit-transform: translate3d(-" + s + "px, 0, 0);-webkit-transition:-webkit-transform " + r + "s linear;"
                }, 50);
                setTimeout(function() {
                    R.line[l] = undefined
                },isShowdTime * 1e3);
                setTimeout(function() {
                    f.parentNode.removeChild(f)
                }, removeTime * 1e3)
            },videoLayout: {width: 800,height: 450},setVideoLayout: function(e, t) {
                if (_ || document.webkitIsFullScreen)
                    return;
                var n = 800, r = n / e * t || 450;
                r > window.innerHeight - 80 && (r = window.innerHeight - 80, n = r / t * e, n = n < 500 ? 500 : n), R.videoLayout.height = r, R.videoLayout.width = n, R.fixVideoLayout()
            },fixVideoLayout: function() {
                _ || document.webkitIsFullScreen ? (o.style.width = "", o.style.marginLeft = "", o.style.height = "", o.style.marginTop = "") : (o.style.width = R.videoLayout.width + "px", o.style.marginLeft = "-" + R.videoLayout.width / 2 + "px", o.style.height = R.videoLayout.height + "px", o.style.marginTop = "-" + R.videoLayout.height / 2 + "px")
            },log: function(e) {
                window.console && window.console.log(e);
                var n = t.cTag("div", i + "log", O, e);
                setTimeout(function() {
                    t.rNode(n)
                }, 1e3)
            }}, U;
        j("hd", function(e) {
            var t = f.currentTime;
            if (e.className == i + "btn " + i + "select"){
                e.className = i + "btn "/*, f.src = e.getAttribute("data-url")*/;}
            else{
            	  e.className = i + "btn " + i + "select";
            }  
            clearTimeout(U);
            var s = function() {
                try {
                    clearTimeout(U), f.currentTime = t
                } catch (e) {
                    U = setTimeout(s, 100)
                }
            };
            youkufix.init();
            s()
        }), j("fullscreen", function() {
            document.webkitIsFullScreen ? document.webkitCancelFullScreen() : a.webkitRequestFullScreen()
        }), j("allscreen", function() {
            if (document.webkitIsFullScreen)
                return;
            _ ? (o.className = i + "layer", N.className = i + "btn " + i + "allscreen", _ = !1) : (o.className = i + "layer " + i + "full", N.className = i + "btn " + i + "select " + i + "allscreen", _ = !0), R.fixVideoLayout()
        }), j("close", function() {
            if (document.webkitIsFullScreen)
                document.webkitCancelFullScreen();
            else {
                t.rNode(o), t.rNode(s), t.rNode(O), clearTimeout(M), P = !0, f.src = "", f.pause();
                try {
                    q.parentNode.insertBefore(I, q), q.parentNode.removeChild(q)
                } catch (e) {
                }
                delete window.isHTML5Player,g.removeEventListener("dblclick", V, !1), document.body.removeEventListener("keydown", $, !1), f.removeEventListener("canplay", K, !1), y.removeEventListener("mousedown", Y, !1), E.removeEventListener("mousedown", Z, !1), document.removeEventListener("mouseup", et, !1), document.removeEventListener("mousemove", tt, !1), a.removeEventListener("mousemove", playerMousemoveHandler, !1), B.destroy();
                t.callIosFun("close");
            }
        });
        var z = 0, W;
        j("center", function() {
            z++, clearTimeout(W), W = setTimeout(function() {
                z == 1 && (f.paused ? f.play() : f.pause()), z = 0
            }, 0)
        });
        var X = function() {
            D ? (s.className = i + "cover", D = !1) : (s.className = i + "cover " + i + "block", D = !0)
        };
        s.addEventListener("dblclick", X, !1);
        var V = function() {
            if (P)
                return;
            document.webkitIsFullScreen ? document.webkitCancelFullScreen() : a.webkitRequestFullScreen()
        };
        g.addEventListener("dblclick", V, !1);
        var $ = function(e) {
            if (P)
                return;
            switch (e.keyCode) {
                case 37:
                    f.currentTime > 20 ? f.currentTime = f.currentTime - 20 : "", e.preventDefault(), e.preventDefault();
                    break;
                case 39:
                    f.currentTime < f.duration - 20 ? f.currentTime = f.currentTime + 20 : "", e.preventDefault(), e.preventDefault();
                    break;
                case 40:
                    f.volume > .1 ? f.volume = f.volume - .1 : "", e.preventDefault(), e.preventDefault();
                    break;
                case 38:
                    f.volume < .9 ? f.volume = f.volume + .1 : "", e.preventDefault(), e.preventDefault();
                    break;
                case 32:
                    f[f.paused ? "play" : "pause"](), e.preventDefault()
            }
        };
        document.body.addEventListener("keydown", $, !1);
        var K = function() {
            if (P)
                return;
            f.play(), R.setVideoLayout(f.videoWidth, f.videoHeight)
        };
        f.addEventListener("canplay", K, !1);
        var Q = !1, G = !1, Y = function() {
            if (P)
                return;
            Q = !0
        };
        y.addEventListener("mousedown", Y, !1);
        var Z = function() {
            if (P)
                return;
            G = !0
        };
        E.addEventListener("mousedown", Z, !1);
        var et = function(e) {
            if (P)
                return;
            var n = 0, r = 0;
            Q && (n = e.clientX - t.getLeft(b), r = n / b.offsetWidth, r = r > 1 ? 1 : r, r = r < 0 ? 0 : r, f.currentTime = f.duration * r, w.style.width = r * 100 + "%"), G && (n = e.clientX - t.getLeft(S), r = n / S.offsetWidth, r = r > 1 ? 1 : r, r = r < 0 ? 0 : r, t.callIosFun("setVolume",r), x.style.width = r * 100 + "%"), Q = !1, G = !1
        };
        document.addEventListener("mouseup", et, !1);
        var tt = function(e) {
            if (P)
                return;
            var n = 0, r = 0;
            Q && (n = e.clientX - t.getLeft(b), r = n / b.offsetWidth, r = r > 1 ? 1 : r, r = r < 0 ? 0 : r, f.currentTime = f.duration * r, w.style.width = r * 100 + "%"), G && (n = e.clientX - t.getLeft(S), r = n / S.offsetWidth, r = r > 1 ? 1 : r, r = r < 0 ? 0 : r, t.callIosFun("setVolume",r), x.style.width = r * 100 + "%")
        };
        document.addEventListener("mousemove", tt, !1);
        var nt = !0, rt = setTimeout(function() {
            l.className = i + "ctrlbar"
        }, 3e3);
        playerMousemoveHandler = function() {
            clearTimeout(rt), l.className != i + "ctrlbar " + i + "ctrlbarhover" && (l.className = i + "ctrlbar " + i + "ctrlbarhover"), rt = setTimeout(function() {
                l.className = i + "ctrlbar"
            }, 3e3)
        }, a.addEventListener("mousemove", playerMousemoveHandler, !1);
        var it = -1, st = 0, ot = !1, ut = function() {
            if (n)
                return;
            Q || w.style.width != f.currentTime / f.duration * 100 + "%" && (w.style.width = f.currentTime / f.duration * 100 + "%"), G || x.style.width != f.volume * 100 + "%" && (x.style.width = f.volume * 100 + "%"), h.innerHTML = R.formatTime(f.currentTime) + " / " + R.formatTime(f.duration), f.duration == 10 && R.url.length && (f.src = R.url[0]), f.paused ? g.className != i + "center " + i + "pause" && (g.className = i + "center " + i + "pause") : g.className != i + "center" && (g.className = i + "center"), it != f.currentTime || f.ended || f.readyState == 3 || f.readyState == 4 || f.readyState == 5 ? ot || (u.innerHTML = "youkufix", ot = !0) : (ot && (u.innerHTML = "&#x52C7;&#x6562;&#x7684;&#x5C11;&#x5E74;&#x8BF7;&#x8010;&#x5FC3;&#xFF0C;&#x5C11;&#x5973;&#x52AA;&#x529B;&#x7948;&#x7977;&#x4E2D;...", ot = !1), g.className != i + "center " + i + "loading" && (g.className = i + "center " + i + "loading")), R.commentLoop && (st % 2 == 0 && R.commentLoop(it = f.currentTime), ++st > 10 && (st = 0)), M = setTimeout(ut, 500)
        };
        ut();
        R.addEndListener();
        var at = [];
        return {add: function(n) {
                try {
                    n && at.push(n(t, e))
                } catch (r) {
                }
            },init: function() {
                for (var e = 0, i = at.length; e < i; e++)
                    if (at[e] && at[e].reg && at[e].call) {
                        R.showPlayer(), R.log("&#x64AD;&#x653E;&#x5668;&#x521D;&#x59CB;&#x5316;");
                        try {
                            at[e].call(function(e) {
                                R.setUrl(e.urls), R.log("&#x83B7;&#x53D6;&#x64AD;&#x653E;&#x6E90;&#x5730;&#x5740;"),
                                       R.setFlashElement(t.byId(e.flashElementId)), e.comment && (R.initComment(), R.log("&#x521D;&#x59CB;&#x5316;&#x5F39;&#x5E55;"), setTimeout(function() {
                                  R.showComment(e.comment), R.log("&#x751F;&#x6210;&#x5F39;&#x5E55;")
                                }, 100))
                            })
                        } catch (s) {
                        }
                        R.log("&#x51C6;&#x5907;&#x5B8C;&#x6BD5;");
                        break
                    }
            }}
    }();
    var hd_type = "3gphd";
    youkufix.add(function(e, t) {
        r = function(n, r, m) {
            e.jsonp("http://v.youku.com/player/getPlayList/VideoIDS/" + n + "/Pf/4/ctype/12/ev/1?__callback=", function(t) {
                function n(e) {
                    var t = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\\:._-1234567890".split(""), n = [], r;
                    for (var i = 0, s = t.length; i < s; i++)
                        e = (e * 211 + 30031) % 65536, r = Math.floor(e / 65536 * t.length), n.push(t[r]), t.splice(r, 1);
                    return n.join("")
                }
                function s(e, t) {
                    var r = n(t), i = e.split("*"), s = [], o;
                    for (var u = 0; u < i.length; u++)
                        o = parseInt(i[u], 10), s.push(r.charAt(o));
                    return s.join("")
                }
                
                var o = new Date;
                if(!t.data[0].streamfileids[hd_type]){
                    for(var i in t.data[0].streamsizes)
                    {
                        if("3gphd,mp4,flv".match(i))
                            hd_type=i;
                    }
                }
                u = s(t.data[0].streamfileids[hd_type], t.data[0].seed);
                u.substring(0, u.length - 1);
                
                function youku_f(e, s) 
                {
                    var t = [];
                    for (var i = 0; i < 256; i++)
                        t[i] = i;
                    var a = 0;
                    for (var i = 0; i < 256; i++) {
                        a = ((a + t[i]) + e[i % e.length].charCodeAt()) % 256;
                        var d = t[a];
                        t[a] = t[i];
                        t[i] = d;
                    }
                    var r = [];
                    for (var i = 0, j = 0, k = 0; i < s.length; i++) {
                        k = (k + 1) % 256;
                        j = (j + t[k]) % 256;
                        var d = t[k];
                        t[k] = t[j];
                        t[j] = d;
                        r[i] = String.fromCharCode(s[i].charCodeAt() ^ t[(t[j] + t[k]) % 256]);
                    }
                    return r.join("");
                }
                
                var b = new Base64();
                s = b.base64decode(t.data[0]["ep"]);
                s = youku_f("becaf9be", s);
                
                sid = s.substr(0, s.search('_'))
                token = s.substr(s.search('_') + 1, s.length)
                
                function new_ep(e) {
                    ep = youku_f("bf7e5f01", e);
                    ep = b.base64encode(ep);
                    var nep = "";
                    for (var x = 0; x < ep.length; x++) {
                        if (ep.charAt(x) == '+') {
                            nep += "%2b";
                        } 
                        else if (ep.charAt(x) == '/') {
                            nep += "%2f";
                        } 
                        else if (ep.charAt(x) == '=') {
                            nep += "%3d";
                        } 
                        else {
                            nep += ep.charAt(x);
                        }
                    }
                    return nep;
                }
                
                var sUrl = [];
                function getMP4Url(h) 
                {
                	  var i=sUrl.length;
                    var url = "http://k.youku.com/player/getFlvPath/sid/";
                    url += sid;
                    url += i < 10 ? "_0" + i + "/st/" : "_" + i + "/st/";
                    url += !"flv".match(hd_type)?"mp4":hd_type;
                    url += "/fileid/";
                    var arry = u.split('');
                    if (i < 10) {
                        arry[9] = i;
                    } else {
                        arry[8] = parseInt(i / 10);
                        arry[9] = i % 10;
                    }
                    u = arry.join('');
                    url += u;
                    url += "?K=";
                    url += t.data[0].segs[h][i].k
                    url += "&hd=1&myp=0&ts=";
                    url += t.data[0].segs[h][i].seconds;
                    url += "&ypp=0&ctype=12&ev=1&token=";
                    url += token;
                    url += "&oip=";
                    url += 12312312;
                    url += "&ep=";
                    
                    url += new_ep(sid + '_' + u + '_' + token);
                    
                    e.jsonp(url + "&callback=", function(e) {
                        sUrl[sUrl.length] = e[0].server;
                        if(sUrl.length>=t.data[0].segs[h].length){
                            r(sUrl, m);
                        }else{
                            getMP4Url(h);
                        }
                    });
                }
                getMP4Url(hd_type);
                
                if(hd_type.match("3gphd")){
                    var hd_size = 0;
                    for(var i in t.data[0].streamsizes)
                    {
                        if("3gphd,mp4,flv".match(i))
                        if(parseInt(t.data[0].streamsizes[i])>parseInt(hd_size)){
                            hd_size=t.data[0].streamsizes[i];hd_type=i;}
                    }}else {hd_type="3gphd"}
            })
        }, o = function(t) {
               r(window.videoId2, t, "")
        }
        return {reg: true,call: function(e) {
                return o(function(t, n) {
                    return e({urls: t,flashElementId: "area-player",comment: n})
                })
            }}
    }), youkufix.init()
})()
