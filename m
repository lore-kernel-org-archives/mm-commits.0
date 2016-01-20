From: akpm@linux-foundation.org
Subject: [folded-merged] maintainers-add-git-url-for-swiotlb.patch removed from -mm tree
Date: Wed, 20 Jan 2016 14:46:39 -0800
Message-ID: <56a00e4f.t8pWT8ALXT5UwzJn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbcATWqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git URL for swiotlb
has been removed from the -mm tree.  Its filename was
     maintainers-add-git-url-for-swiotlb.patch

This patch was dropped because it was folded into maintainers-add-git-url-for-apm-driver.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: MAINTAINERS: add git URL for swiotlb

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-for-swiotlb MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-swiotlb
+++ a/MAINTAINERS
@@ -10493,6 +10493,7 @@ F:	arch/x86/boot/video*
 SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git
 S:	Supported
 F:	lib/swiotlb.c
 F:	arch/*/kernel/pci-swiotlb.c
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

iio-core-introduce-iio-software-triggers-fix.patch
maintainers-add-git-url-for-apm-driver.patch
maintainers-add-git-url-for-xtensa.patch
maintainers-fix-tree-format-for-tpm.patch
maintainers-add-git-url-for-uml.patch
maintainers-add-git-url-for-vfio.patch
maintainers-add-git-url-for-vhost.patch
maintainers-update-git-url-for-xfs.patch

