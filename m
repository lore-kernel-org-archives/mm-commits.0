From: akpm@linux-foundation.org
Subject: [merged] maintainers-ivtv-devel-is-moderated.patch removed from -mm tree
Date: Thu, 14 Jan 2010 13:20:33 -0800
Message-ID: <201001142120.o0ELKXnx031607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab0ANVVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 16:21:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, awalls@radix.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: ivtv-devel is moderated
has been removed from the -mm tree.  Its filename was
     maintainers-ivtv-devel-is-moderated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: ivtv-devel is moderated
From: Jiri Slaby <jslaby@suse.cz>

Mark ivtv-devel@ivtvdriver.org as 'moderated for non-subscribers'.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-ivtv-devel-is-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-ivtv-devel-is-moderated
+++ a/MAINTAINERS
@@ -1649,7 +1649,7 @@ F:	sound/pci/cs5535audio/
 CX18 VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 M:	Andy Walls <awalls@radix.net>
-L:	ivtv-devel@ivtvdriver.org
+L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
@@ -3037,7 +3037,7 @@ F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
-L:	ivtv-devel@ivtvdriver.org
+L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
infiniband-use-rlimit-helpers.patch
char-synclink-remove-unnecessary-checks.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

