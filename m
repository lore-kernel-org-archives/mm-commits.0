From: akpm@linux-foundation.org
Subject: - mn10300-define-so_mark.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:10 -0800
Message-ID: <200802250044.m1P0iA4B006086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYBYAot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: define SO_MARK
has been removed from the -mm tree.  Its filename was
     mn10300-define-so_mark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MN10300: define SO_MARK
From: David Howells <dhowells@redhat.com>

Define SO_MARK for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/socket.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-mn10300/socket.h~mn10300-define-so_mark include/asm-mn10300/socket.h
--- a/include/asm-mn10300/socket.h~mn10300-define-so_mark
+++ a/include/asm-mn10300/socket.h
@@ -52,4 +52,6 @@
 #define SO_TIMESTAMPNS		35
 #define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
 
+#define SO_MARK			36
+
 #endif /* _ASM_SOCKET_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-unionfs.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch
