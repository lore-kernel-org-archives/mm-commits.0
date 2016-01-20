From: akpm@linux-foundation.org
Subject: [folded-merged]
 maintainers-add-git-url-for-wireless-drivers.patch removed from -mm tree
Date: Wed, 20 Jan 2016 14:44:59 -0800
Message-ID: <56a00deb.lw9KjNkVR1AWrtmR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963AbcATWpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git URL for wireless drivers
has been removed from the -mm tree.  Its filename was
     maintainers-add-git-url-for-wireless-drivers.patch

This patch was dropped because it was folded into maintainers-add-git-url-for-apm-driver.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: MAINTAINERS: add git URL for wireless drivers

Also fixup the tailing /

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-git-url-for-wireless-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-wireless-drivers
+++ a/MAINTAINERS
@@ -7595,7 +7595,8 @@ NETWORKING DRIVERS (WIRELESS)
 M:	Kalle Valo <kvalo@codeaurora.org>
 L:	linux-wireless@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
 S:	Maintained
 F:	drivers/net/wireless/
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

iio-core-introduce-iio-software-triggers-fix.patch
maintainers-add-git-url-for-apm-driver.patch
maintainers-add-git-url-for-devicetree.patch
maintainers-update-git-url-for-pcmcia.patch
maintainers-update-git-url-for-pstore.patch
maintainers-update-git-url-for-ath10k.patch
maintainers-add-git-url-for-hexagon.patch
maintainers-add-git-url-for-reset.patch
maintainers-add-git-url-for-s390.patch
maintainers-fix-tree-format-for-samsung-thermal.patch
maintainers-add-git-url-for-md.patch
maintainers-add-git-url-for-squashfs.patch
maintainers-add-git-url-for-swiotlb.patch
maintainers-add-git-url-for-xtensa.patch
maintainers-fix-tree-format-for-tpm.patch
maintainers-add-git-url-for-uml.patch
maintainers-add-git-url-for-vfio.patch
maintainers-add-git-url-for-vhost.patch
maintainers-update-git-url-for-xfs.patch

