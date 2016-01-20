From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-coredump-prevent-core-path-components-fix.patch removed from -mm tree
Date: Wed, 20 Jan 2016 14:35:35 -0800
Message-ID: <56a00bb7.v5GLVvjRymlkUH7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbcATWfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jann@thejh.net, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-coredump-prevent-core-path-components-fix
has been removed from the -mm tree.  Its filename was
     fs-coredump-prevent-core-path-components-fix.patch

This patch was dropped because it was folded into fs-coredump-prevent-core-path-components.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-coredump-prevent-core-path-components-fix

tweak code comment

Cc: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/coredump.c~fs-coredump-prevent-core-path-components-fix fs/coredump.c
--- a/fs/coredump.c~fs-coredump-prevent-core-path-components-fix
+++ a/fs/coredump.c
@@ -121,7 +121,7 @@ int cn_esc_printf(struct core_name *cn,
 	if (ret == 0) {
 		/*
 		 * Ensure that this coredump name component can't cause the
-		 * resulting corefile path to contain a ".." or "." component.
+		 * resulting corefile path to consist of a ".." or ".".
 		 */
 		if ((cn->used - cur == 1 && cn->corename[cur] == '.') ||
 				(cn->used - cur == 2 && cn->corename[cur] == '.'
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-coredump-prevent-core-path-components.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

