From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unused-nfsd-pattern.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:43:27 -0700
Message-ID: <53ea6e5f.ZEao4WTC1LbMpSYQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49016 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbaHLTn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:27 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2671193pab.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unused NFSD pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unused-nfsd-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove unused NFSD pattern

A series of commits by Christoph Hellwig removed all the files in this
directory, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unused-nfsd-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unused-nfsd-pattern
+++ a/MAINTAINERS
@@ -5144,7 +5144,6 @@ L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
 F:	fs/nfsd/
-F:	include/linux/nfsd/
 F:	include/uapi/linux/nfsd/
 F:	fs/lockd/
 F:	fs/nfs_common/
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

