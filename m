From: akpm@linux-foundation.org
Subject: - omfs-add-maintainers-entry.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:33 -0700
Message-ID: <200807262115.m6QLFXV6019748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676AbYGZVQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     omfs: add MAINTAINERS entry
has been removed from the -mm tree.  Its filename was
     omfs-add-maintainers-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omfs: add MAINTAINERS entry
From: Bob Copeland <me@bobcopeland.com>

omfs: add MAINTAINERS entry

Add the MAINTAINERS entry for OMFS.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~omfs-add-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~omfs-add-maintainers-entry
+++ a/MAINTAINERS
@@ -3123,6 +3123,12 @@ W:	http://oss.oracle.com/projects/ocfs2/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 
+OMFS FILESYSTEM
+P:	Bob Copeland
+M:	me@bobcopeland.com
+L:	linux-karma-devel@lists.sourceforge.net
+S:	Maintained
+
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
_

Patches currently in -mm which might be from me@bobcopeland.com are

origin.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch

