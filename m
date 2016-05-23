From: akpm@linux-foundation.org
Subject: [patch 16/84] nilfs2: remove FSF mailing address from GPL notices
Date: Mon, 23 May 2016 16:23:06 -0700
Message-ID: <574390da.P495BlmC9UcQ34fU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcEWXXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove FSF mailing address from GPL notices

This removes the extra paragraph which mentions FSF address in GPL
notices from source code of nilfs2 and avoids the checkpatch.pl error
related to it.

Link: http://lkml.kernel.org/r/1461935747-10380-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c         |    4 ----
 fs/nilfs2/alloc.h         |    4 ----
 fs/nilfs2/bmap.c          |    4 ----
 fs/nilfs2/bmap.h          |    4 ----
 fs/nilfs2/btnode.c        |    4 ----
 fs/nilfs2/btnode.h        |    4 ----
 fs/nilfs2/btree.c         |    4 ----
 fs/nilfs2/btree.h         |    4 ----
 fs/nilfs2/cpfile.c        |    4 ----
 fs/nilfs2/cpfile.h        |    4 ----
 fs/nilfs2/dat.c           |    4 ----
 fs/nilfs2/dat.h           |    4 ----
 fs/nilfs2/dir.c           |    4 ----
 fs/nilfs2/direct.c        |    4 ----
 fs/nilfs2/direct.h        |    4 ----
 fs/nilfs2/file.c          |    4 ----
 fs/nilfs2/gcinode.c       |    4 ----
 fs/nilfs2/ifile.c         |    4 ----
 fs/nilfs2/ifile.h         |    4 ----
 fs/nilfs2/inode.c         |    4 ----
 fs/nilfs2/ioctl.c         |    4 ----
 fs/nilfs2/mdt.c           |    4 ----
 fs/nilfs2/mdt.h           |    4 ----
 fs/nilfs2/namei.c         |    4 ----
 fs/nilfs2/nilfs.h         |    4 ----
 fs/nilfs2/page.c          |    4 ----
 fs/nilfs2/page.h          |    4 ----
 fs/nilfs2/recovery.c      |    4 ----
 fs/nilfs2/segbuf.c        |    4 ----
 fs/nilfs2/segbuf.h        |    4 ----
 fs/nilfs2/segment.c       |    4 ----
 fs/nilfs2/segment.h       |    4 ----
 fs/nilfs2/sufile.c        |    4 ----
 fs/nilfs2/sufile.h        |    4 ----
 fs/nilfs2/super.c         |    4 ----
 fs/nilfs2/the_nilfs.c     |    4 ----
 fs/nilfs2/the_nilfs.h     |    4 ----
 include/linux/nilfs2_fs.h |    4 ----
 38 files changed, 152 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/alloc.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Original code was written by Koji Sato <koji@osrg.net>.
  * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
  *                                Amagai Yoshiji <amagai@osrg.net>.
diff -puN fs/nilfs2/alloc.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/alloc.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Original code was written by Koji Sato <koji@osrg.net>.
  * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
  *                                Amagai Yoshiji <amagai@osrg.net>.
diff -puN fs/nilfs2/bmap.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/bmap.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/bmap.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/bmap.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/btnode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/btnode.c
--- a/fs/nilfs2/btnode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/btnode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * This file was originally written by Seiji Kihara <kihara@osrg.net>
  * and fully revised by Ryusuke Konishi <ryusuke@osrg.net> for
  * stabilization and simplification.
diff -puN fs/nilfs2/btnode.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/btnode.h
--- a/fs/nilfs2/btnode.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/btnode.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Seiji Kihara <kihara@osrg.net>
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>
  */
diff -puN fs/nilfs2/btree.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/btree.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/btree.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/btree.h
--- a/fs/nilfs2/btree.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/btree.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/cpfile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/cpfile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/cpfile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/cpfile.h
--- a/fs/nilfs2/cpfile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/cpfile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/dat.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/dat.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/dat.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/dat.h
--- a/fs/nilfs2/dat.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/dat.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/dir.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/dir.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>
  */
 /*
diff -puN fs/nilfs2/direct.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/direct.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/direct.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/direct.h
--- a/fs/nilfs2/direct.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/direct.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/file.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/file.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>,
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
diff -puN fs/nilfs2/gcinode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/gcinode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
  *            and Ryusuke Konishi <ryusuke@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
diff -puN fs/nilfs2/ifile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/ifile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  *
diff -puN fs/nilfs2/ifile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/ifile.h
--- a/fs/nilfs2/ifile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/ifile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>
  *
diff -puN fs/nilfs2/inode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/inode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/ioctl.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/ioctl.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/mdt.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/mdt.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff -puN fs/nilfs2/mdt.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/mdt.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff -puN fs/nilfs2/namei.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/namei.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
  *                       Ryusuke Konishi <ryusuke@osrg.net>
  */
diff -puN fs/nilfs2/nilfs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/nilfs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
diff -puN fs/nilfs2/page.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/page.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>,
  *            Seiji Kihara <kihara@osrg.net>.
  */
diff -puN fs/nilfs2/page.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/page.h
--- a/fs/nilfs2/page.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/page.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>,
  *            Seiji Kihara <kihara@osrg.net>.
  */
diff -puN fs/nilfs2/recovery.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/recovery.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff -puN fs/nilfs2/segbuf.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/segbuf.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/segbuf.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/segbuf.h
--- a/fs/nilfs2/segbuf.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/segbuf.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/segment.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/segment.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/segment.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/segment.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/sufile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/sufile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  */
diff -puN fs/nilfs2/sufile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/sufile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff -puN fs/nilfs2/super.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/super.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 /*
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/the_nilfs.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/fs/nilfs2/the_nilfs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff -puN include/linux/nilfs2_fs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-remove-fsf-mailing-address-from-gpl-notices
+++ a/include/linux/nilfs2_fs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
_
