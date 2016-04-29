From: akpm@linux-foundation.org
Subject: + nilfs2-clean-up-old-e-mail-addresses.patch added to -mm tree
Date: Fri, 29 Apr 2016 13:40:21 -0700
Message-ID: <5723c6b5.5rLQk+xTOwEagQUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbcD2UkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: clean up old e-mail addresses
has been added to the -mm tree.  Its filename is
     nilfs2-clean-up-old-e-mail-addresses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-clean-up-old-e-mail-addresses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-clean-up-old-e-mail-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: clean up old e-mail addresses

E-mail addresses of osrg.net domain are no longer available.  This
removes them from authorship notices and prevents reporters from being
confused.

Link: http://lkml.kernel.org/r/1461935747-10380-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c         |    5 ++---
 fs/nilfs2/alloc.h         |    5 ++---
 fs/nilfs2/bmap.c          |    2 +-
 fs/nilfs2/bmap.h          |    2 +-
 fs/nilfs2/btnode.c        |    5 ++---
 fs/nilfs2/btnode.h        |    4 ++--
 fs/nilfs2/btree.c         |    2 +-
 fs/nilfs2/btree.h         |    2 +-
 fs/nilfs2/cpfile.c        |    2 +-
 fs/nilfs2/cpfile.h        |    2 +-
 fs/nilfs2/dat.c           |    2 +-
 fs/nilfs2/dat.h           |    2 +-
 fs/nilfs2/dir.c           |    2 +-
 fs/nilfs2/direct.c        |    2 +-
 fs/nilfs2/direct.h        |    2 +-
 fs/nilfs2/file.c          |    3 +--
 fs/nilfs2/gcinode.c       |    5 ++---
 fs/nilfs2/ifile.c         |    4 ++--
 fs/nilfs2/ifile.h         |    4 ++--
 fs/nilfs2/inode.c         |    2 +-
 fs/nilfs2/ioctl.c         |    2 +-
 fs/nilfs2/mdt.c           |    2 +-
 fs/nilfs2/mdt.h           |    2 +-
 fs/nilfs2/namei.c         |    3 +--
 fs/nilfs2/nilfs.h         |    3 +--
 fs/nilfs2/page.c          |    3 +--
 fs/nilfs2/page.h          |    3 +--
 fs/nilfs2/recovery.c      |    2 +-
 fs/nilfs2/segbuf.c        |    2 +-
 fs/nilfs2/segbuf.h        |    2 +-
 fs/nilfs2/segment.c       |    2 +-
 fs/nilfs2/segment.h       |    2 +-
 fs/nilfs2/sufile.c        |    4 ++--
 fs/nilfs2/sufile.h        |    2 +-
 fs/nilfs2/super.c         |    2 +-
 fs/nilfs2/the_nilfs.c     |    2 +-
 fs/nilfs2/the_nilfs.h     |    2 +-
 include/linux/nilfs2_fs.h |    3 +--
 38 files changed, 46 insertions(+), 56 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/alloc.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Original code was written by Koji Sato <koji@osrg.net>.
- * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
- *                                Amagai Yoshiji <amagai@osrg.net>.
+ * Originally written by Koji Sato.
+ * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
 
 #include <linux/types.h>
diff -puN fs/nilfs2/alloc.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/alloc.h
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Original code was written by Koji Sato <koji@osrg.net>.
- * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
- *                                Amagai Yoshiji <amagai@osrg.net>.
+ * Originally written by Koji Sato.
+ * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
 
 #ifndef _NILFS_ALLOC_H
diff -puN fs/nilfs2/bmap.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/bmap.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/fs.h>
diff -puN fs/nilfs2/bmap.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/bmap.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_BMAP_H
diff -puN fs/nilfs2/btnode.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/btnode.c
--- a/fs/nilfs2/btnode.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/btnode.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * This file was originally written by Seiji Kihara <kihara@osrg.net>
- * and fully revised by Ryusuke Konishi <ryusuke@osrg.net> for
- * stabilization and simplification.
+ * Originally written by Seiji Kihara.
+ * Fully revised by Ryusuke Konishi for stabilization and simplification.
  *
  */
 
diff -puN fs/nilfs2/btnode.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/btnode.h
--- a/fs/nilfs2/btnode.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/btnode.h
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Seiji Kihara <kihara@osrg.net>
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Seiji Kihara.
+ * Revised by Ryusuke Konishi.
  */
 
 #ifndef _NILFS_BTNODE_H
diff -puN fs/nilfs2/btree.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/btree.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/slab.h>
diff -puN fs/nilfs2/btree.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/btree.h
--- a/fs/nilfs2/btree.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/btree.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_BTREE_H
diff -puN fs/nilfs2/cpfile.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/cpfile.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/kernel.h>
diff -puN fs/nilfs2/cpfile.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/cpfile.h
--- a/fs/nilfs2/cpfile.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/cpfile.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_CPFILE_H
diff -puN fs/nilfs2/dat.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/dat.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/types.h>
diff -puN fs/nilfs2/dat.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/dat.h
--- a/fs/nilfs2/dat.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/dat.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_DAT_H
diff -puN fs/nilfs2/dir.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/dir.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>
+ * Modified for NILFS by Amagai Yoshiji.
  */
 /*
  *  linux/fs/ext2/dir.c
diff -puN fs/nilfs2/direct.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/direct.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/errno.h>
diff -puN fs/nilfs2/direct.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/direct.h
--- a/fs/nilfs2/direct.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/direct.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_DIRECT_H
diff -puN fs/nilfs2/file.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/file.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>,
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Amagai Yoshiji and Ryusuke Konishi.
  */
 
 #include <linux/fs.h>
diff -puN fs/nilfs2/gcinode.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/gcinode.c
@@ -13,9 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
- *            and Ryusuke Konishi <ryusuke@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Seiji Kihara, Amagai Yoshiji, and Ryusuke Konishi.
+ * Revised by Ryusuke Konishi.
  *
  */
 /*
diff -puN fs/nilfs2/ifile.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/ifile.c
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Amagai Yoshiji.
+ * Revised by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/ifile.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/ifile.h
--- a/fs/nilfs2/ifile.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/ifile.h
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Amagai Yoshiji <amagai@osrg.net>
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Amagai Yoshiji.
+ * Revised by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/inode.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/inode.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/ioctl.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/ioctl.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #include <linux/fs.h>
diff -puN fs/nilfs2/mdt.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/mdt.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #include <linux/buffer_head.h>
diff -puN fs/nilfs2/mdt.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/mdt.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #ifndef _NILFS_MDT_H
diff -puN fs/nilfs2/namei.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/namei.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
- *                       Ryusuke Konishi <ryusuke@osrg.net>
+ * Modified for NILFS by Amagai Yoshiji and Ryusuke Konishi.
  */
 /*
  *  linux/fs/ext2/namei.c
diff -puN fs/nilfs2/nilfs.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/nilfs.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Koji Sato and Ryusuke Konishi.
  */
 
 #ifndef _NILFS_H
diff -puN fs/nilfs2/page.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/page.c
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>,
- *            Seiji Kihara <kihara@osrg.net>.
+ * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
 #include <linux/pagemap.h>
diff -puN fs/nilfs2/page.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/page.h
--- a/fs/nilfs2/page.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/page.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>,
- *            Seiji Kihara <kihara@osrg.net>.
+ * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
 #ifndef _NILFS_PAGE_H
diff -puN fs/nilfs2/recovery.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/recovery.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 
 #include <linux/buffer_head.h>
diff -puN fs/nilfs2/segbuf.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/segbuf.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/segbuf.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/segbuf.h
--- a/fs/nilfs2/segbuf.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/segbuf.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 #ifndef _NILFS_SEGBUF_H
diff -puN fs/nilfs2/segment.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/segment.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/segment.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/segment.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 #ifndef _NILFS_SEGMENT_H
diff -puN fs/nilfs2/sufile.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/sufile.c
@@ -13,8 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
- * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ * Written by Koji Sato.
+ * Revised by Ryusuke Konishi.
  */
 
 #include <linux/kernel.h>
diff -puN fs/nilfs2/sufile.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/sufile.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>.
+ * Written by Koji Sato.
  */
 
 #ifndef _NILFS_SUFILE_H
diff -puN fs/nilfs2/super.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/super.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  */
 /*
  *  linux/fs/ext2/super.c
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/the_nilfs.c
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-clean-up-old-e-mail-addresses fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/fs/nilfs2/the_nilfs.h
@@ -13,7 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Ryusuke Konishi.
  *
  */
 
diff -puN include/linux/nilfs2_fs.h~nilfs2-clean-up-old-e-mail-addresses include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-clean-up-old-e-mail-addresses
+++ a/include/linux/nilfs2_fs.h
@@ -13,8 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
  *
- * Written by Koji Sato <koji@osrg.net>
- *            Ryusuke Konishi <ryusuke@osrg.net>
+ * Written by Koji Sato and Ryusuke Konishi.
  */
 /*
  *  linux/include/linux/ext2_fs.h
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch

