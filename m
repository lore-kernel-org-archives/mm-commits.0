From: akpm@linux-foundation.org
Subject: +
 partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch added to -mm tree
Date: Mon, 20 May 2013 16:42:07 -0700
Message-ID: <519ab4cf.0hikQdXNo2W1VvTn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3ETXmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: + partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch added to -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:42:07 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files: compile aix.c if configured
has been added to the -mm tree.  Its filename is
     partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

