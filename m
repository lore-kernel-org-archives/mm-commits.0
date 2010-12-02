From: akpm@linux-foundation.org
Subject: [merged] maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch removed from -mm tree
Date: Thu, 02 Dec 2010 13:07:04 -0800
Message-ID: <201012022107.oB2L7wRO008681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143Ab0LBVIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2010 16:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, airlied@linux.ie, chris@chris-wilson.co.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: intel-gfx is a subscribers-only mailing list
has been removed from the -mm tree.  Its filename was
     maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: intel-gfx is a subscribers-only mailing list
From: Joe Perches <joe@perches.com>

Mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-intel-gfx-is-a-subscribers-only-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-intel-gfx-is-a-subscribers-only-mailing-list
+++ a/MAINTAINERS
@@ -2073,7 +2073,7 @@ F:	include/drm/
 
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Chris Wilson <chris@chris-wilson.co.uk>
-L:	intel-gfx@lists.freedesktop.org
+L:	intel-gfx@lists.freedesktop.org (subscribers-only)
 L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git
 S:	Supported
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

