From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch removed from -mm tree
Date: Mon, 08 Jul 2013 15:32:23 -0700
Message-ID: <51db3df7.Q1vQFO9/bCmGXVJe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3GHWcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: [folded-merged] partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch removed from -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:32:23 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files: compile aix.c if configured
has been removed from the -mm tree.  Its filename was
     partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch

This patch was dropped because it was folded into partitions-add-aix-lvm-partition-support-files.patch

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: partitions-add-aix-lvm-partition-support-files: compile aix.c if configured

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/partitions/Makefile~partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured block/partitions/Makefile
--- a/block/partitions/Makefile~partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured
+++ a/block/partitions/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_BLOCK) := check.o
 obj-$(CONFIG_ACORN_PARTITION) += acorn.o
 obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
 obj-$(CONFIG_ATARI_PARTITION) += atari.o
+obj-$(CONFIG_AIX_PARTITION) += aix.o
 obj-$(CONFIG_MAC_PARTITION) += mac.o
 obj-$(CONFIG_LDM_PARTITION) += ldm.o
 obj-$(CONFIG_MSDOS_PARTITION) += msdos.o
_

Patches currently in -mm which might be from phdm@macqel.be are

partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
partitions-add-aix-lvm-partition-support-files.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

