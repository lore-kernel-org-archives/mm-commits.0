From: akpm@linux-foundation.org
Subject: [merged] kernel-doc-preferred-ending-marker-and-examples.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:33 -0800
Message-ID: <200902122025.n1CKPX9l014823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbZBLU0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:26:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, robert.w.love@intel.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: preferred ending marker and examples
has been removed from the -mm tree.  Its filename was
     kernel-doc-preferred-ending-marker-and-examples.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: preferred ending marker and examples
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc-nano-HOWTO.txt to use */ as the ending marker in kernel-doc
examples and state that */ is the preferred ending marker.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-preferred-ending-marker-and-examples Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-preferred-ending-marker-and-examples
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -43,7 +43,8 @@ Only comments so marked will be consider
 and any comment so marked must be in kernel-doc format.  Do not use
 "/**" to be begin a comment block unless the comment block contains
 kernel-doc formatted comments.  The closing comment marker for
-kernel-doc comments can be either "*/" or "**/".
+kernel-doc comments can be either "*/" or "**/", but "*/" is
+preferred in the Linux kernel tree.
 
 Kernel-doc comments should be placed just before the function
 or data structure being described.
@@ -63,7 +64,7 @@ Example kernel-doc function comment:
  * comment lines.
  *
  * The longer description can have multiple paragraphs.
- **/
+ */
 
 The first line, with the short description, must be on a single line.
 
@@ -85,7 +86,7 @@ Example kernel-doc data structure commen
  *		perhaps with more lines and words.
  *
  * Longer description of this structure.
- **/
+ */
 
 The kernel-doc function comments describe each parameter to the
 function, in order, with the @name lines.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv-fix-header-struct-usage.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
rtl8187se-depends-on-wireless_ext.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
docbook-split-kernel-api-add-device-drivers-book.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

