From: akpm@linux-foundation.org
Subject: + maintainers-add-git-url-for-apm-driver.patch added to -mm tree
Date: Fri, 18 Dec 2015 15:33:03 -0800
Message-ID: <567497af.NlO33C+IJbhk0+UM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbLRXdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 18:33:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jikos@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git URL for APM driver
has been added to the -mm tree.  Its filename is
     maintainers-add-git-url-for-apm-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-git-url-for-apm-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-git-url-for-apm-driver.patch

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
Subject: MAINTAINERS: add git URL for APM driver

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiri Kosina <jikos@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-for-apm-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-apm-driver
+++ a/MAINTAINERS
@@ -781,6 +781,7 @@ F:	sound/aoa/
 APM DRIVER
 M:	Jiri Kosina <jikos@kernel.org>
 S:	Odd fixes
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 F:	include/uapi/linux/apm_bios.h
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

