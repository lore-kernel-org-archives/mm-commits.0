From: akpm@linux-foundation.org
Subject: + dax-some-small-updates-to-daxtxt-documentation.patch added to
 -mm tree
Date: Thu, 14 Jul 2016 14:47:31 -0700
Message-ID: <57880873.nZsAiGIW1ccSQ0bx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbcGNVrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 17:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: some small updates to dax.txt documentation
has been added to the -mm tree.  Its filename is
     dax-some-small-updates-to-daxtxt-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-some-small-updates-to-daxtxt-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-some-small-updates-to-daxtxt-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dax-some-small-updates-to-daxtxt-documentation.patch

