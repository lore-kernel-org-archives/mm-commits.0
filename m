From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-dma-buffer-sharing-patterns.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:44:13 -0700
Message-ID: <53ea6e8d.eROPsZ4NHMdDWsCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:55792 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbaHLToO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:14 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1921205obc.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update DMA BUFFER SHARING patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-dma-buffer-sharing-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update DMA BUFFER SHARING patterns

One pattern per F: line please...

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-dma-buffer-sharing-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-dma-buffer-sharing-patterns
+++ a/MAINTAINERS
@@ -2943,7 +2943,9 @@ L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
 F:	drivers/dma-buf/
-F:	include/linux/dma-buf* include/linux/reservation.h include/linux/*fence.h
+F:	include/linux/dma-buf*
+F:	include/linux/reservation.h
+F:	include/linux/*fence.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

