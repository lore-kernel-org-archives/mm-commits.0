From: akpm@linux-foundation.org
Subject: [merged] documentation-changes-minor-corrections.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:00 -0700
Message-ID: <201103232044.p2NKiaE6029089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933473Ab1CWUom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists@nerdbynature.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/Changes: minor corrections 
has been removed from the -mm tree.  Its filename was
     documentation-changes-minor-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/Changes: minor corrections 
From: Christian Kujau <lists@nerdbynature.de>

I noticed the 'mcelog' program had no comment and then ended up "fixing"
a few more things:

  * reiserfsck -V does not print "reiserfsprogs" (any more?)
  * is "udevinfo" still shipped? udevd certainly is
  * grub2 doesn't have a 'grub' binary
  * add a "# how to get the mcelog version" comment

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Changes |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/Changes~documentation-changes-minor-corrections Documentation/Changes
--- a/Documentation/Changes~documentation-changes-minor-corrections
+++ a/Documentation/Changes
@@ -35,7 +35,7 @@ o  util-linux             2.10o         
 o  module-init-tools      0.9.10                  # depmod -V
 o  e2fsprogs              1.41.4                  # e2fsck -V
 o  jfsutils               1.1.3                   # fsck.jfs -V
-o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
+o  reiserfsprogs          3.6.3                   # reiserfsck -V
 o  xfsprogs               2.6.0                   # xfs_db -V
 o  squashfs-tools         4.0                     # mksquashfs -version
 o  btrfs-progs            0.18                    # btrfsck
@@ -46,9 +46,9 @@ o  isdn4k-utils           3.1pre1       
 o  nfs-utils              1.0.5                   # showmount --version
 o  procps                 3.2.0                   # ps --version
 o  oprofile               0.9                     # oprofiled --version
-o  udev                   081                     # udevinfo -V
-o  grub                   0.93                    # grub --version
-o  mcelog		  0.6
+o  udev                   081                     # udevd --version
+o  grub                   0.93                    # grub --version || grub-install --version
+o  mcelog                 0.6                     # mcelog --version
 o  iptables               1.4.2                   # iptables -V
 
 
_

Patches currently in -mm which might be from lists@nerdbynature.de are

origin.patch

