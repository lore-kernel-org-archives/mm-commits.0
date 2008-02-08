From: akpm@linux-foundation.org
Subject: - docbook-dmapool-fix-fatal-changed-filename.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:42 -0800
Message-ID: <200802080801.m1881N6R013959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbYBHICu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:02:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     docbook: dmapool: fix fatal changed filename
has been removed from the -mm tree.  Its filename was
     docbook-dmapool-fix-fatal-changed-filename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: dmapool: fix fatal changed filename
From: Randy Dunlap <randy.dunlap@oracle.com>

Docbook fatal error, file was moved:
docproc: linux-2.6.24-git15/drivers/base/dmapool.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-dmapool-fix-fatal-changed-filename Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-dmapool-fix-fatal-changed-filename
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -165,6 +165,7 @@ X!Ilib/string.c
 !Emm/vmalloc.c
 !Imm/page_alloc.c
 !Emm/mempool.c
+!Emm/dmapool.c
 !Emm/page-writeback.c
 !Emm/truncate.c
      </sect1>
@@ -371,7 +372,6 @@ X!Iinclude/linux/device.h
 !Edrivers/base/class.c
 !Edrivers/base/firmware_class.c
 !Edrivers/base/transport_class.c
-!Edrivers/base/dmapool.c
 <!-- Cannot be included, because
      attribute_container_add_class_device_adapter
  and attribute_container_classdev_to_container
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
