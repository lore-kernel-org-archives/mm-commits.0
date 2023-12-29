Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC6112E4E
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jW64Bgkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05387C433C8;
	Fri, 29 Dec 2023 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876852;
	bh=+DVZ8SuMGIuxQ7gofdZiyVDm9TbHWwBuzWdThQzHJvk=;
	h=Date:To:From:Subject:From;
	b=jW64BgkfYmeo2U7Si2oZmOsU1qxlL/NX2l+J/zytBFBDn63hu65M8GCVWId/FEXak
	 ejCrWZ7ihOYKlSnL4QItm3lxfeUmkG44HM8n73MupQqBbrW9R1eL4DhIdLtfdQxW7E
	 fO8qhiIVCzcXxSwH0Urlby+bX1m973n+Zx6loa8c=
Date: Fri, 29 Dec 2023 11:07:31 -0800
To: mm-commits@vger.kernel.org,martin.krastev@broadcom.com,maaz.mombasawala@broadcom.com,ian.forbes@broadcom.com,florian.fainelli@broadcom.com,zack.rusin@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-change-vmwarecom-addresses-to-broadcomcom.patch removed from -mm tree
Message-Id: <20231229190732.05387C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: change vmware.com addresses to broadcom.com
has been removed from the -mm tree.  Its filename was
     maintainers-change-vmwarecom-addresses-to-broadcomcom.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zack Rusin <zack.rusin@broadcom.com>
Subject: MAINTAINERS: change vmware.com addresses to broadcom.com
Date: Sun, 24 Dec 2023 00:20:36 -0500

Update the email addresses for vmwgfx and vmmouse to reflect the fact that
VMware is now part of Broadcom.

Add a .mailmap entry because the vmware.com address will start bouncing
soon.

Link: https://lkml.kernel.org/r/20231224052036.603621-1-zack.rusin@broadcom.com
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Ian Forbes <ian.forbes@broadcom.com>
Cc: Martin Krastev <martin.krastev@broadcom.com>
Cc: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/.mailmap~maintainers-change-vmwarecom-addresses-to-broadcomcom
+++ a/.mailmap
@@ -631,4 +631,5 @@ Wolfram Sang <wsa@kernel.org> <w.sang@pe
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yusuke Goda <goda.yusuke@renesas.com>
+Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
--- a/MAINTAINERS~maintainers-change-vmwarecom-addresses-to-broadcomcom
+++ a/MAINTAINERS
@@ -6903,8 +6903,8 @@ T:	git git://anongit.freedesktop.org/drm
 F:	drivers/gpu/drm/vboxvideo/
 
 DRM DRIVER FOR VMWARE VIRTUAL GPU
-M:	Zack Rusin <zackr@vmware.com>
-R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
+M:	Zack Rusin <zack.rusin@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	dri-devel@lists.freedesktop.org
 S:	Supported
 T:	git git://anongit.freedesktop.org/drm/drm-misc
@@ -23203,9 +23203,8 @@ F:	drivers/misc/vmw_vmci/
 F:	include/linux/vmw_vmci*
 
 VMWARE VMMOUSE SUBDRIVER
-M:	Zack Rusin <zackr@vmware.com>
-R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Zack Rusin <zack.rusin@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-input@vger.kernel.org
 S:	Supported
 F:	drivers/input/mouse/vmmouse.c
_

Patches currently in -mm which might be from zack.rusin@broadcom.com are


