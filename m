Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0F6F07B
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476492; cv=none; b=j34CCBnNTAlIilmcpUS91H8859nTFA+E1sTRtayMyj1HcFKrhrBEGZ+V/0yBLaP2vVRiBpiQETTiL50wOlHkRAwBQuzD2MmmFvYO/GUKSiuh7EzzYLKm6Jk0wThP5EWSA1y9pMEl8ohqCfrI9+/zotdljLBNL8lEGdZvz3zFd/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476492; c=relaxed/simple;
	bh=jtuu5OBSZyoBPBO1gsqEh1Uhf3KGTyKdy6ouJQRkvNs=;
	h=Date:To:From:Subject:Message-Id; b=K/y0k2rFRgyrTMU3/IxWkBAlNXAYCicI8BvrsI0K0M1ST7fZmOQhHjxxYYAGexpuqjo+DJjAyUHq9ZoIBm7THFA8fjOh0eV9I/kze2YkiD999rkqIY/Lj45RJlp6Kn2PPp9essXCrPUBnBbNuZSCqq1PQK3hvO0m5+NxIOx78Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ykPmC8Ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykPmC8Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CEAC43399;
	Tue, 26 Mar 2024 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476491;
	bh=jtuu5OBSZyoBPBO1gsqEh1Uhf3KGTyKdy6ouJQRkvNs=;
	h=Date:To:From:Subject:From;
	b=ykPmC8Ae3dTOZQLkm5uVYKAa3W7cvFn35NB1g0OKgLJacX+SFoCUyMky+ilBQiT+i
	 s7cu1ZhLjIKmxRM0wEqqSJhd1Y5e5nVk4+1MhI4eLiJBDmI88jxx6Swon6IrGFK0f6
	 aBceYwQfKHGhuVip8K0IGwz7d+WPSFs9GpI2sD6M=
Date: Tue, 26 Mar 2024 11:08:10 -0700
To: mm-commits@vger.kernel.org,f.fainelli@gmail.com,cdleonard@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-leonard-crestez.patch removed from -mm tree
Message-Id: <20240326180810.E7CEAC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Leonard Crestez
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-leonard-crestez.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leonard Crestez <cdleonard@gmail.com>
Subject: mailmap: update entry for Leonard Crestez
Date: Sat, 16 Mar 2024 20:28:37 +0200

Put my personal email first because NXP employment ended some time ago.
Also add my old intel email address.

Link: https://lkml.kernel.org/r/f568faa0-2380-4e93-a312-b80c1e367645@gmail.com
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-leonard-crestez
+++ a/.mailmap
@@ -340,7 +340,8 @@ Lee Jones <lee@kernel.org> <joneslee@goo
 Lee Jones <lee@kernel.org> <lee.jones@canonical.com>
 Lee Jones <lee@kernel.org> <lee.jones@linaro.org>
 Lee Jones <lee@kernel.org> <lee@ubuntu.com>
-Leonard Crestez <leonard.crestez@nxp.com> Leonard Crestez <cdleonard@gmail.com>
+Leonard Crestez <cdleonard@gmail.com> <leonard.crestez@nxp.com>
+Leonard Crestez <cdleonard@gmail.com> <leonard.crestez@intel.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
_

Patches currently in -mm which might be from cdleonard@gmail.com are


