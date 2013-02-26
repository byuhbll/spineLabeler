Spine Labeler Application for Symphony, v.2.1.x
===============================================

The Spine Labeler Application (spineLabeler) provides a basic PHP-based web interface to scan barcodes into.  Upon form submission, the application will generate the appropriate spine label, containing the call number (and location, if desired) of the item.  The web form will return an .docx document containing the spine labels (with one printed on each page).

WARNING: OSTINATO IS DESIGNED FOR EXPERIENCED USERS ONLY. IT DOES NOT PROVIDE EXTENSIVE DATA OR COMMAND VALIDATION, SO THERE IS POTENTIAL TO DAMAGE YOUR SYMPHONY DATABASE OR EVEN YOUR HOST SYSTEM. DO NOT USE THIS LIBRARY UNLESS YOU KNOW WHAT YOU ARE DOING, AND RESTRICT ACCESS TO TRUSTED USERS ONLY!!

NO WARRANTY OR SUPPORT OF ANY KIND IS PROVIDED FOR THIS SOFTWARE.

Installation and Usage
----------------------

Configure your instance of the spineLabeler application by copying Sirsi/Labels.example.pm to Sirsi/Labels.pm.  Additionally, you will want to populate the contents of that file with the appropriate location labels for your library.  Changes to the format of the .docx file can be made by modifying the Sirsi/Docx.pm library - .docx files are simply XML archives.  However, the XML can be quite confusing and it is easy to make a mistake, so be sure to save a backup of the Docx.pm file before modifying.

No additional installation is required to use this software.  Simply drop it in your web directory at the desired location.

License
-------
Copyright (c) 2013 Brigham Young University

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of Brigham Young University nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Symphony is owned and copyrighted by SirsiDynix.  All rights reserved.
