From: akpm@linux-foundation.org
Subject: + update-readmedrm-bugzilla-7933.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:14:55 -0800
Message-ID: <200702052214.l15MEtc1000530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36190 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937AbXBEWPA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:15:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     update README.drm (bugzilla #7933)
has been added to the -mm tree.  Its filename is
     update-readmedrm-bugzilla-7933.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update README.drm (bugzilla #7933)
From: Randy Dunlap <randy.dunlap@oracle.com>

Update URLs in drivers/char/drm/README.drm, to take care of kernel bugzilla
#7933.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/README.drm |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/char/drm/README.drm~update-readmedrm-bugzilla-7933 drivers/char/drm/README.drm
--- a/drivers/char/drm/README.drm~update-readmedrm-bugzilla-7933
+++ a/drivers/char/drm/README.drm
@@ -1,6 +1,6 @@
 ************************************************************
 * For the very latest on DRI development, please see:      *
-*     http://dri.sourceforge.net/                          *
+*     http://dri.freedesktop.org/wiki/FrontPage            *
 ************************************************************
 
 The Direct Rendering Manager (drm) is a device-independent kernel-level
@@ -26,21 +26,20 @@ ways:
 
 
 Documentation on the DRI is available from:
-    http://precisioninsight.com/piinsights.html
+    http://dri.freedesktop.org/wiki/Documentation
+    http://sourceforge.net/project/showfiles.php?group_id=387
+    http://dri.sourceforge.net/doc/
 
 For specific information about kernel-level support, see:
 
     The Direct Rendering Manager, Kernel Support for the Direct Rendering
     Infrastructure
-    http://precisioninsight.com/dr/drm.html
+    http://dri.sourceforge.net/doc/drm_low_level.html
 
     Hardware Locking for the Direct Rendering Infrastructure
-    http://precisioninsight.com/dr/locking.html
+    http://dri.sourceforge.net/doc/hardware_locking_low_level.html
 
     A Security Analysis of the Direct Rendering Infrastructure
-    http://precisioninsight.com/dr/security.html
+    http://dri.sourceforge.net/doc/security_low_level.html
 
 ************************************************************
-* For the very latest on DRI development, please see:      *
-*     http://dri.sourceforge.net/                          *
-************************************************************
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
update-readmedrm-bugzilla-7933.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
mtd-add-missing-kernel-doc-item.patch
git-ocfs2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
