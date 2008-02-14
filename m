From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-fs-pipec-notation.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:32 -0500
Message-ID: <200802150225.m1F2PpZr015189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757661AbYBOC0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix fs/pipe.c notation
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-fs-pipec-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: fix fs/pipe.c notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix several kernel-doc notation errors in fs/pipe.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/pipe.c~kernel-doc-fix-fs-pipec-notation fs/pipe.c
--- a/fs/pipe.c~kernel-doc-fix-fs-pipec-notation
+++ a/fs/pipe.c
@@ -171,7 +171,7 @@ static void anon_pipe_buf_release(struct
  *
  * Description:
  *	This function returns a kernel virtual address mapping for the
- *	passed in @pipe_buffer. If @atomic is set, an atomic map is provided
+ *	pipe_buffer passed in @buf. If @atomic is set, an atomic map is provided
  *	and the caller has to be careful not to fault before calling
  *	the unmap function.
  *
@@ -208,15 +208,15 @@ void generic_pipe_buf_unmap(struct pipe_
 }
 
 /**
- * generic_pipe_buf_steal - attempt to take ownership of a @pipe_buffer
+ * generic_pipe_buf_steal - attempt to take ownership of a &pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
  * @buf:	the buffer to attempt to steal
  *
  * Description:
- *	This function attempts to steal the @struct page attached to
+ *	This function attempts to steal the &struct page attached to
  *	@buf. If successful, this function returns 0 and returns with
  *	the page locked. The caller may then reuse the page for whatever
- *	he wishes, the typical use is insertion into a different file
+ *	he wishes; the typical use is insertion into a different file
  *	page cache.
  */
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
@@ -238,7 +238,7 @@ int generic_pipe_buf_steal(struct pipe_i
 }
 
 /**
- * generic_pipe_buf_get - get a reference to a @struct pipe_buffer
+ * generic_pipe_buf_get - get a reference to a &struct pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
  * @buf:	the buffer to get a reference to
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-remove-fastcall.patch
git-acpi.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
