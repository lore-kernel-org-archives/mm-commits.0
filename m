From: akpm@linux-foundation.org
Subject: - docbook-drop-z85230-library-from-kernel-api.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:58 -0500
Message-ID: <200802150226.m1F2QHCF015213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759692AbYBOC05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     docbook: drop z85230 library from kernel-api
has been removed from the -mm tree.  Its filename was
     docbook-drop-z85230-library-from-kernel-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
kernel-doc-remove-fastcall.patch
git-acpi.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
