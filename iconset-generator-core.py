#!/usr/bin/env python3

import os
import click
from svgpathtools import svg2paths, Path

basepath = os.path.dirname(os.path.abspath( __file__ ))


def write_hass_file(path, namespace, svgs):
    """Write merged SVG paths into Home-Assistant compatible HTML file."""

    if not namespace:
        namespace = "hass-iconset"

    hass_head = f"<ha-iconset-svg name=\"{namespace}\" size=\"1024\"><svg><defs>\n"
    hass_tail = "</defs></svg></ha-iconset-svg>\n"
    tpl = "<g id=\"{0}\" transform=\"scale(32.00 32.00)\"><path d=\"{1}\"/></g>\n"

    

    with open(os.path.join(path, f"{namespace}.html"), "w") as hass:
        hass.write(hass_head)
        for n, svg in enumerate(svgs):
            hass.write(tpl.format(svg["name"], svg["path"]))
        hass.write(hass_tail)


def write_docs_file(path, namespace, svgs):
    """Write merged SVG paths into a HTML file that can be used to look up the wanted icon."""

    if not namespace:
        namespace = "hass-iconset"

    html_head = """
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="utf-8">

            <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100&display=swap" rel="stylesheet"> 
            
            <style>/**
            *** SIMPLE GRID
            *** (C) ZACH COLE 2016
            **/

            @import url(https://fonts.googleapis.com/css?family=Lato:400,300,300italic,400italic,700,700italic);

            /* UNIVERSAL */

            html,
            body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            left: 0;
            top: 0;
            font-size: 100%;
            }

            /* ROOT FONT STYLES */

            * {
            font-family: 'Lato', Helvetica, sans-serif;
            color: #333447;
            line-height: 1.5;
            }

            /* TYPOGRAPHY */

            h1 {
            font-size: 2.5rem;
            }

            h2 {
            font-size: 2rem;
            }

            h3 {
            font-size: 1.375rem;
            }

            h4 {
            font-size: 1.125rem;
            }

            h5 {
            font-size: 1rem;
            }

            h6 {
            font-size: 0.875rem;
            }

            p {
            font-size: 1.125rem;
            font-weight: 200;
            line-height: 1.8;
            }

            .font-light {
            font-weight: 300;
            }

            .font-regular {
            font-weight: 400;
            }

            .font-heavy {
            font-weight: 700;
            }

            /* POSITIONING */

            .left {
            text-align: left;
            }

            .right {
            text-align: right;
            }

            .center {
            text-align: center;
            margin-left: auto;
            margin-right: auto;
            }

            .justify {
            text-align: justify;
            }

            /* ==== GRID SYSTEM ==== */

            .container {
            width: 90%;
            margin-left: auto;
            margin-right: auto;
            }

            .row {
            position: relative;
            width: 100%;
            }

            .row [class^="col"] {
            float: left;
            margin: 0.5rem 2%;
            min-height: 0.125rem;
            }

            .col-1,
            .col-2,
            .col-3,
            .col-4,
            .col-5,
            .col-6,
            .col-7,
            .col-8,
            .col-9,
            .col-10,
            .col-11,
            .col-12 {
            width: 96%;
            }

            .col-1-sm {
            width: 4.33%;
            }

            .col-2-sm {
            width: 12.66%;
            }

            .col-3-sm {
            width: 21%;
            }

            .col-4-sm {
            width: 29.33%;
            }

            .col-5-sm {
            width: 37.66%;
            }

            .col-6-sm {
            width: 46%;
            }

            .col-7-sm {
            width: 54.33%;
            }

            .col-8-sm {
            width: 62.66%;
            }

            .col-9-sm {
            width: 71%;
            }

            .col-10-sm {
            width: 79.33%;
            }

            .col-11-sm {
            width: 87.66%;
            }

            .col-12-sm {
            width: 96%;
            }

            .row::after {
                content: "";
                display: table;
                clear: both;
            }

            .hidden-sm {
            display: none;
            }

            @media only screen and (min-width: 33.75em) {  /* 540px */
            .container {
                width: 80%;
            }
            }

            @media only screen and (min-width: 45em) {  /* 720px */
            .col-1 {
                width: 4.33%;
            }

            .col-2 {
                width: 12.66%;
            }

            .col-3 {
                width: 21%;
            }

            .col-4 {
                width: 29.33%;
            }

            .col-5 {
                width: 37.66%;
            }

            .col-6 {
                width: 46%;
            }

            .col-7 {
                width: 54.33%;
            }

            .col-8 {
                width: 62.66%;
            }

            .col-9 {
                width: 71%;
            }

            .col-10 {
                width: 79.33%;
            }

            .col-11 {
                width: 87.66%;
            }

            .col-12 {
                width: 96%;
            }

            .hidden-sm {
                display: block;
            }
            }

            </style>

            <style>
            html { 
                font-family: 'Roboto', sans-serif; 
                font-size: 12px;
            }
            </style>
        </head>
        <body>
        <div class="container">
            <div class="row">
    """

    html_tail = """
            </div>
        </div>
        </body>
    </html>
    """

    tpl = """
        <div class="col-2 center">
            <svg height="64" width="64">
                <g id="{0}" transform="scale(2)"><path d="{1}"></path></g>
            </svg>
            <div class="center" style="margin-bottom: 1em;">{0}</div>
        </div>
        """

    with open(os.path.join(path, f"{namespace}-docs.html"), "w") as html:
        html.write(html_head)
        for n, svg in enumerate(svgs):
            html.write(tpl.format(svg["name"], svg["path"]))
            if n % 6 == 5:
                html.write("\n\t\t\t</div>")
                html.write("\n\t\t\t<div class=\"row\">\n")
        html.write(html_tail)

@click.command()
@click.argument('path', type=click.Path(exists=True))
@click.option('-n', '--namespace', default=None, help='Namespace of the iconset, you will call it from hass like <namespace>:<iconname>')
@click.option('-e', '--enum', default=False, is_flag=True, help='Enumerate icons like icon-0, icon-1 and so on or use the svg filename as iconname')
def convert_svgs(path, namespace, enum):

    workpath = os.path.abspath(path)
    svgs = []
    counter = 0
    for file in os.listdir(path):
        
        if not file.endswith("svg"):
            continue
        paths, attributes = svg2paths(os.path.join(workpath,file))
        r = []
        for p in paths:
            r.append(p.d())
        path = " ".join(r)
        if enum:
            svgs.append({"name": f"icon-{counter}", "path": path})
            counter += 1
        else:
            svgs.append({"name": file[:-4], "path": path})
    write_hass_file(workpath, namespace, svgs)
    write_docs_file(workpath, namespace, svgs)
    
if __name__ == "__main__":
    convert_svgs()