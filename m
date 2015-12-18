From: akpm@linux-foundation.org
Subject: + maintainers-add-git-url-for-kvm-arm.patch added to -mm tree
Date: Fri, 18 Dec 2015 15:33:42 -0800
Message-ID: <567497d6.rALGXmBzsfgbbSRI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbLRXdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 18:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git URL for KVM/ARM
has been added to the -mm tree.  Its filename is
     maintainers-add-git-url-for-kvm-arm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-git-url-for-kvm-arm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-git-url-for-kvm-arm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: MAINTAINERS: add git URL for KVM/ARM

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-for-kvm-arm MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-kvm-arm
+++ a/MAINTAINERS
@@ -6132,6 +6132,7 @@ M:	Marc Zyngier <marc.zyngier@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
 W:	http://systems.cs.columbia.edu/projects/kvm-arm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 S:	Supported
 F:	arch/arm/include/uapi/asm/kvm*
 F:	arch/arm/include/asm/kvm*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

iio-core-introduce-iio-software-triggers-fix.patch
maintainers-add-git-url-for-apm-driver.patch
maintainers-add-git-url-for-at91.patch
maintainers-add-git-url-for-rockchip.patch
maintainers-add-git-url-for-arm64.patch
maintainers-add-git-url-for-ath6kl.patch
maintainers-add-git-url-for-backlight.patch
maintainers-add-git-url-for-chrome.patch
maintainers-add-git-url-for-cris.patch
maintainers-add-git-url-for-cryptodev.patch
maintainers-update-git-url-for-dlm.patch
maintainers-add-git-url-for-ecryptfs.patch
maintainers-fix-git-url-for-edac.patch
maintainers-add-git-url-for-ext4.patch
maintainers-add-git-url-for-hwspinlock.patch
maintainers-add-git-url-for-integrity.patch
maintainers-add-git-url-for-ipvs.patch
maintainers-add-git-url-for-nfsd.patch
maintainers-add-git-url-for-kvm-s390.patch
maintainers-add-git-url-for-kvm-arm.patch
maintainers-add-git-url-for-kgdb.patch
maintainers-add-git-url-for-nvdimm.patch
maintainers-add-git-url-for-metag.patch
maintainers-add-git-url-for-wireless-drivers.patch
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
maintainers-add-git-url-for-tile.patch
maintainers-fix-tree-format-for-tpm.patch
maintainers-add-git-url-for-uml.patch
maintainers-add-git-url-for-vfio.patch
maintainers-add-git-url-for-vhost.patch
maintainers-update-git-url-for-xfs.patch

