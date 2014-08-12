From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-cifs-location.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:43:05 -0700
Message-ID: <53ea6e49.yACDooR5gZXC6cWP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53800 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaHLTnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:06 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1306423vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update cifs location
has been removed from the -mm tree.  Its filename was
     maintainers-update-cifs-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update cifs location

Commit 30706a545417 ("cifs: create a new Documentation/ directory
and move docfiles into it") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-cifs-location MAINTAINERS
--- a/MAINTAINERS~maintainers-update-cifs-location
+++ a/MAINTAINERS
@@ -2415,7 +2415,7 @@ W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
-F:	Documentation/filesystems/cifs.txt
+F:	Documentation/filesystems/cifs/
 F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

