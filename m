Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0665633557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671915; cv=none; b=SC+mP0/F4l443lwMomul3twV7UeqwoP+3KDb6pfl2BNjDSZfsaNJpFpLZpxXSP7q/UlJ+ZRKPulODiZkWIvzHoZX9DSmNpNlKYkcLzRzRRYkVpVOqdSJSslxsfDhl/DoV87RkfJBk7AfhxE0acYSXg3Tb5DWnXK8rviuJvlc6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671915; c=relaxed/simple;
	bh=EbocjI9XkmQ/KAdZ/OYm0P9b413EOA1YU8bSHuflrgI=;
	h=Date:To:From:Subject:Message-Id; b=UyyXxNwxWVYaViuSBz9dsRORdkn8s8V4cXtDjHvJiw62IzTYgy8+PrDpOmMCInaj4FAQESx8TW2dIBVRvB7WeRdh9K1F6jgAyTv5XnbgFrkkbQ+aNv/AagJvhf9YeB6YSm5kF3Q/7xgE9pv369rMKiaP/xSg+8uHzjiPJ64D+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBQbtRww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBQbtRww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC7EC2BC9E;
	Sat, 28 Mar 2026 04:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671914;
	bh=EbocjI9XkmQ/KAdZ/OYm0P9b413EOA1YU8bSHuflrgI=;
	h=Date:To:From:Subject:From;
	b=uBQbtRwwZKUcAsgdURMAcmTl/A4JdEQR+xB0/BpED56CxcHPklrXJnjxNZhRRUwJI
	 /Laj9/tWZ/nQp3/a3iCYnHZzM8Uavj3H764MLUj4aQ0LpJUDLxeHtgYOcLDOVNvhXk
	 ci6zl8X5BKgUDrdprmKbVhTmnIp5M+LFRqt1j4ek=
Date: Fri, 27 Mar 2026 21:25:14 -0700
To: mm-commits@vger.kernel.org,linux@gurudas.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-guru-das-srinageshs-email-address.patch removed from -mm tree
Message-Id: <20260328042514.CFC7EC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Guru Das Srinagesh's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-guru-das-srinageshs-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guru Das Srinagesh <linux@gurudas.dev>
Subject: mailmap: update Guru Das Srinagesh's email address
Date: Sun, 01 Mar 2026 18:44:20 -0800

Add my current email address and map previous addresses to it.

Link: https://lkml.kernel.org/r/20260301-gds-mailmap-update-2-v1-1-5691415be73c@gurudas.dev
Signed-off-by: Guru Das Srinagesh <linux@gurudas.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-guru-das-srinageshs-email-address
+++ a/.mailmap
@@ -305,7 +305,10 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
-Guru Das Srinagesh <quic_gurus@quicinc.com> <gurus@codeaurora.org>
+Guru Das Srinagesh <linux@gurudas.dev>
+Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
+Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
+Guru Das Srinagesh <linux@gurudas.dev> <gurooodas@gmail.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> <hamza.mahfooz@amd.com>
_

Patches currently in -mm which might be from linux@gurudas.dev are


