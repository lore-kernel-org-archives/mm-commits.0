From: akpm@linux-foundation.org
Subject: - maintainers-remove-two-dead-e-mail.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:21 -0800
Message-ID: <200702122243.l1CMhLiE013492@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44834 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030238AbXBLWnX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove two dead e-mail
has been removed from the -mm tree.  Its filename was
     maintainers-remove-two-dead-e-mail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: remove two dead e-mail
From: Jiri Slaby <jirislaby@gmail.com>

Cyclades no longer serves the 2 e-mails listed in MAINTAINERS.  Remove them
and mark those entries as Orphaned.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-two-dead-e-mail MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-two-dead-e-mail
+++ a/MAINTAINERS
@@ -1002,14 +1002,12 @@ L:	cycsyn-devel@bazar.conectiva.com.br
 S:	Maintained
 
 CYCLADES ASYNC MUX DRIVER
-M:	async@cyclades.com
 W:	http://www.cyclades.com/
-S:	Supported
+S:	Orphan
 
 CYCLADES PC300 DRIVER
-M:	pc300@cyclades.com
 W:	http://www.cyclades.com/
-S:	Supported
+S:	Orphan
 
 DAMA SLAVE for AX.25
 P:	Joerg Reuter
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-watchdog.patch
shrink_slab-handle-bad-shrinkers.patch
