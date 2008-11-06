From: akpm@linux-foundation.org
Subject: + documentation-update-s390-header-file-paths.patch added to -mm tree
Date: Thu, 06 Nov 2008 15:37:42 -0800
Message-ID: <200811062337.mA6NbgLJ023947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYKFXiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 18:38:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, schwidefsky@de.ibm.com


The patch titled
     documentation: update s390 header file paths
has been added to the -mm tree.  Its filename is
     documentation-update-s390-header-file-paths.patch

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
Subject: documentation: update s390 header file paths
From: Randy Dunlap <randy.dunlap@oracle.com>

Update Documentation/s390/ files to reflect changed header files
locations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/s390/Debugging390.txt |    2 +-
 Documentation/s390/cds.txt          |    2 +-
 Documentation/s390/s390dbf.txt      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/s390/Debugging390.txt~documentation-update-s390-header-file-paths Documentation/s390/Debugging390.txt
--- a/Documentation/s390/Debugging390.txt~documentation-update-s390-header-file-paths
+++ a/Documentation/s390/Debugging390.txt
@@ -1402,7 +1402,7 @@ Syscalls are implemented on Linux for S3
 possibilities of these as the instruction is made up of a  0xA opcode & the second byte being
 the syscall number. They are traced using the simple command.
 TR SVC  <Optional value or range>
-the syscalls are defined in linux/include/asm-s390/unistd.h
+the syscalls are defined in linux/arch/s390/include/asm/unistd.h
 e.g. to trace all file opens just do
 TR SVC 5 ( as this is the syscall number of open )
 
diff -puN Documentation/s390/cds.txt~documentation-update-s390-header-file-paths Documentation/s390/cds.txt
--- a/Documentation/s390/cds.txt~documentation-update-s390-header-file-paths
+++ a/Documentation/s390/cds.txt
@@ -98,7 +98,7 @@ platform. Some of the interface routines
 of them can be found on other Linux platforms implementations too.
 Miscellaneous function prototypes, data declarations, and macro definitions
 can be found in the architecture specific C header file
-linux/include/asm-s390/irq.h.
+linux/arch/s390/include/asm/irq.h.
 
 Overview of CDS interface concepts
 
diff -puN Documentation/s390/s390dbf.txt~documentation-update-s390-header-file-paths Documentation/s390/s390dbf.txt
--- a/Documentation/s390/s390dbf.txt~documentation-update-s390-header-file-paths
+++ a/Documentation/s390/s390dbf.txt
@@ -2,7 +2,7 @@ S390 Debug Feature
 ==================
 
 files: arch/s390/kernel/debug.c
-       include/asm-s390/debug.h
+       arch/s390/include/asm/debug.h
 
 Description:
 ------------
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-update-scheduler-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

