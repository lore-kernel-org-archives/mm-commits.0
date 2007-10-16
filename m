From: akpm@linux-foundation.org
Subject: + comment-typo-in-scripts-kconfig-makefile.patch added to -mm tree
Date: Mon, 15 Oct 2007 17:43:31 -0700
Message-ID: <200710160043.l9G0hVv5001110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757794AbXJPAoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 20:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, randy.dunlap@oracle.com


The patch titled
     Comment typo in scripts/kconfig/Makefile
has been added to the -mm tree.  Its filename is
     comment-typo-in-scripts-kconfig-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Comment typo in scripts/kconfig/Makefile
From: Rob Landley <rob@landley.net>

Typo in comment in scripts/kconfig/Makefile.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/Makefile~comment-typo-in-scripts-kconfig-makefile scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~comment-typo-in-scripts-kconfig-makefile
+++ a/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ help:
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
 
-# Use reursively expanded variables so we do not call gcc unless
+# Use recursively expanded variables so we do not call gcc unless
 # we really need to do so. (Do not call gcc as part of make mrproper)
 HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
 HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
_

Patches currently in -mm which might be from rob@landley.net are

git-arm.patch
git-scsi-misc.patch
docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
add-documentation-rcu-00-index.patch
fix-make-htmldocs-build-break.patch
add-section-ids-to-documentation-docbook-filesystemstmpl.patch
add-documentation-block-00-index.patch
comment-typo-in-scripts-kconfig-makefile.patch
docbook-fix-kernel-api-content.patch
docbook-fix-libata-content.patch
docbook-fix-usb-content.patch
docbook-fix-filesystems-content.patch
