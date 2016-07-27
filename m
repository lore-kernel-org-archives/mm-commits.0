From: akpm@linux-foundation.org
Subject: [merged] dax-some-small-updates-to-daxtxt-documentation.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:58:30 -0700
Message-ID: <57990456.KU1xxZrN7xQrGJHL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcG0S6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: some small updates to dax.txt documentation
has been removed from the -mm tree.  Its filename was
     dax-some-small-updates-to-daxtxt-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: some small updates to dax.txt documentation

These are originally from Matthew Wilcox and were part of his huge
"mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
support.

I'm breaking these small changes out as they stand on their own and add
useful information to Documentation/filesystems/dax.txt.

Link: http://lkml.kernel.org/r/20160714214049.20075-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dax.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/dax.txt~dax-some-small-updates-to-daxtxt-documentation Documentation/filesystems/dax.txt
--- a/Documentation/filesystems/dax.txt~dax-some-small-updates-to-daxtxt-documentation
+++ a/Documentation/filesystems/dax.txt
@@ -49,6 +49,7 @@ These block devices may be used for insp
 - axonram: Axon DDR2 device driver
 - brd: RAM backed block device driver
 - dcssblk: s390 dcss block device driver
+- pmem: NVDIMM persistent memory driver
 
 
 Implementation Tips for Filesystem Writers
@@ -75,8 +76,9 @@ calls to get_block() (for example by a p
 or a write()) work correctly.
 
 These filesystems may be used for inspiration:
-- ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
-- ext4: the fourth extended filesystem, see Documentation/filesystems/ext4.txt
+- ext2: see Documentation/filesystems/ext2.txt
+- ext4: see Documentation/filesystems/ext4.txt
+- xfs:  see Documentation/filesystems/xfs.txt
 
 
 Handling Media Errors
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-fix-comment-about-exceptional-bits.patch

