From: akpm@linux-foundation.org
Subject: + rationalise-randys-address-a-bit.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:30:11 -0700
Message-ID: <200810280630.m9S6UBN1024960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYJ1Ga1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com, rdunlap@xenotime.net


The patch titled
     Rationalise Randy's address a bit
has been added to the -mm tree.  Its filename is
     rationalise-randys-address-a-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Rationalise Randy's address a bit
=46rom: Alan Cox <alan@redhat.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/deviceiobook.tmpl     |    2 +-
 Documentation/DocBook/mcabook.tmpl          |    2 +-
 Documentation/DocBook/wanbook.tmpl          |    2 +-
 Documentation/DocBook/z8530book.tmpl        |    2 +-
 Documentation/isdn/CREDITS                  |    2 +-
 Documentation/networking/dmfe.txt           |    2 +-
 Documentation/scsi/aacraid.txt              |    2 +-
 Documentation/video4linux/bttv/CONTRIBUTORS |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/DocBook/deviceiobook.tmpl~rationalise-randys-ad=
dress-a-bit Documentation/DocBook/deviceiobook.tmpl
--- a/Documentation/DocBook/deviceiobook.tmpl~rationalise-randys-addres=
s-a-bit
+++ a/Documentation/DocBook/deviceiobook.tmpl
@@ -24,7 +24,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff -puN Documentation/DocBook/mcabook.tmpl~rationalise-randys-address=
-a-bit Documentation/DocBook/mcabook.tmpl
--- a/Documentation/DocBook/mcabook.tmpl~rationalise-randys-address-a-b=
it
+++ a/Documentation/DocBook/mcabook.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff -puN Documentation/DocBook/wanbook.tmpl~rationalise-randys-address=
-a-bit Documentation/DocBook/wanbook.tmpl
--- a/Documentation/DocBook/wanbook.tmpl~rationalise-randys-address-a-b=
it
+++ a/Documentation/DocBook/wanbook.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff -puN Documentation/DocBook/z8530book.tmpl~rationalise-randys-addre=
ss-a-bit Documentation/DocBook/z8530book.tmpl
--- a/Documentation/DocBook/z8530book.tmpl~rationalise-randys-address-a=
-bit
+++ a/Documentation/DocBook/z8530book.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff -puN Documentation/isdn/CREDITS~rationalise-randys-address-a-bit D=
ocumentation/isdn/CREDITS
--- a/Documentation/isdn/CREDITS~rationalise-randys-address-a-bit
+++ a/Documentation/isdn/CREDITS
@@ -5,7 +5,7 @@ I want to thank all who contributed to t
 Thomas Bogend=C3=B6rfer (tsbogend@bigbug.franken.de)
   Tester, lots of bugfixes and hints.
=20
-Alan Cox (alan@redhat.com)
+Alan Cox (alan@lxorguk.ukuu.org.uk)
   For help getting into standard-kernel.
=20
 Henner Eisen (eis@baty.hanse.de)
diff -puN Documentation/networking/dmfe.txt~rationalise-randys-address-=
a-bit Documentation/networking/dmfe.txt
--- a/Documentation/networking/dmfe.txt~rationalise-randys-address-a-bi=
t
+++ a/Documentation/networking/dmfe.txt
@@ -60,6 +60,6 @@ Tobias Ringstrom <tori@unhappy.mine.nu>=20
 Contributors:
=20
 Marcelo Tosatti <marcelo@conectiva.com.br>
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
 Jeff Garzik <jgarzik@pobox.com>
 Vojtech Pavlik <vojtech@suse.cz>
diff -puN Documentation/scsi/aacraid.txt~rationalise-randys-address-a-b=
it Documentation/scsi/aacraid.txt
--- a/Documentation/scsi/aacraid.txt~rationalise-randys-address-a-bit
+++ a/Documentation/scsi/aacraid.txt
@@ -128,7 +128,7 @@ Supported Cards/Chipsets
=20
 People
 -------------------------
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
 Christoph Hellwig <hch@infradead.org>	(updates for new-style PCI probi=
ng and SCSI host registration,
 					 small cleanups/fixes)
 Matt Domsch <matt_domsch@dell.com>	(revision ioctl, adapter messages)
diff -puN Documentation/video4linux/bttv/CONTRIBUTORS~rationalise-randy=
s-address-a-bit Documentation/video4linux/bttv/CONTRIBUTORS
--- a/Documentation/video4linux/bttv/CONTRIBUTORS~rationalise-randys-ad=
dress-a-bit
+++ a/Documentation/video4linux/bttv/CONTRIBUTORS
@@ -3,7 +3,7 @@ Contributors to bttv:
 Michael Chu <mmchu@pobox.com>
   AverMedia fix and more flexible card recognition
=20
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
   Video4Linux interface and 2.1.x kernel adaptation
=20
 Chris Kleitsch
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
rationalise-randys-address-a-bit.patch
linux-next.patch
pata_it821x-in-2627-works-but-no-lba48-and-hdparm-t-is-slower.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
