From: akpm@linux-foundation.org
Subject: + kernel-doc-preferred-ending-marker-and-examples.patch added to -mm tree
Date: Fri, 06 Feb 2009 11:52:20 -0800
Message-ID: <200902061952.n16JqK3E031209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZBFTw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:52:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, robert.w.love@intel.com


The patch titled
     kernel-doc: preferred ending marker and examples
has been added to the -mm tree.  Its filename is
     kernel-doc-preferred-ending-marker-and-examples.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-doc-preferred-ending-marker-and-examples.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch

