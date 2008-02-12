From: akpm@linux-foundation.org
Subject: + docbook-drop-z85230-library-from-kernel-api.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:21:43 -0800
Message-ID: <200802122321.m1CNLhYn028177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbYBLXWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, alan@redhat.com


The patch titled
     docbook: drop z85230 library from kernel-api
has been added to the -mm tree.  Its filename is
     docbook-drop-z85230-library-from-kernel-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: drop z85230 library from kernel-api
From: Randy Dunlap <randy.dunlap@oracle.com>

Drop z85230 support library info from kernel-api since it's duplicated in
the Z85230 book.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-drop-z85230-library-from-kernel-api Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-drop-z85230-library-from-kernel-api
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -449,11 +449,6 @@ X!Isound/sound_firmware.c
 !Edrivers/serial/8250.c
   </chapter>
 
-  <chapter id="z85230">
-     <title>Z85230 Support Library</title>
-!Edrivers/net/wan/z85230.c
-  </chapter>
-
   <chapter id="fbdev">
      <title>Frame Buffer Library</title>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-fix-fs-pipec-notation.patch
docbook-move-pipe-and-splice-to-filesystems-docbook.patch
docbook-sunrpc-filenames-and-notation-fixes.patch
docbook-make-a-networking-book-and-fix-a-few-errors.patch
docbook-drop-z85230-library-from-kernel-api.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
