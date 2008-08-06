From: akpm@linux-foundation.org
Subject: - docbook-fix-s390-fatal-error-after-header-files-moved.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:22 -0700
Message-ID: <200808062057.m76KvMnD014763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYHFU7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     docbook: fix s390 fatal error after header files moved
has been removed from the -mm tree.  Its filename was
     docbook-fix-s390-fatal-error-after-header-files-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix s390 fatal error after header files moved
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix (fatal error) s390 docbook file to handle renamed header files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/s390-drivers.tmpl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/DocBook/s390-drivers.tmpl~docbook-fix-s390-fatal-error-after-header-files-moved Documentation/DocBook/s390-drivers.tmpl
--- a/Documentation/DocBook/s390-drivers.tmpl~docbook-fix-s390-fatal-error-after-header-files-moved
+++ a/Documentation/DocBook/s390-drivers.tmpl
@@ -100,7 +100,7 @@
       the hardware structures represented here, please consult the Principles
       of Operation.
     </para>
-!Iinclude/asm-s390/cio.h
+!Iarch/s390/include/asm/cio.h
     </sect1>
     <sect1 id="ccwdev">
      <title>ccw devices</title>
@@ -114,7 +114,7 @@
       ccw device structure. Device drivers must not bypass those functions
       or strange side effects may happen.
     </para>
-!Iinclude/asm-s390/ccwdev.h
+!Iarch/s390/include/asm/ccwdev.h
 !Edrivers/s390/cio/device.c
 !Edrivers/s390/cio/device_ops.c
     </sect1>
@@ -125,7 +125,7 @@
 	measurement data which is made available by the channel subsystem
 	for each channel attached device.
   </para>
-!Iinclude/asm-s390/cmb.h
+!Iarch/s390/include/asm/cmb.h
 !Edrivers/s390/cio/cmf.c
     </sect1>
   </chapter>
@@ -142,7 +142,7 @@
   </para>
    <sect1 id="ccwgroupdevices">
     <title>ccw group devices</title>
-!Iinclude/asm-s390/ccwgroup.h
+!Iarch/s390/include/asm/ccwgroup.h
 !Edrivers/s390/cio/ccwgroup.c
    </sect1>
   </chapter>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
git-kbuild-fixes.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

