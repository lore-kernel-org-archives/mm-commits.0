From: akpm@linux-foundation.org
Subject: - documentation-update-s390-header-file-paths.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:13 -0800
Message-ID: <200901072220.n07MKDfe019501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413AbZAGWin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     documentation: update s390 header file paths
has been removed from the -mm tree.  Its filename was
     documentation-update-s390-header-file-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

