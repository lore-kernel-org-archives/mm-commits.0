Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13830359A68
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 20:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137377; cv=none; b=MIsXR1/+sPscPc/VcE+SPD5TQNlYijVWrYFlftgMzTNmBCtXkgtm7u7Wonvp+IxQw/yh0KQ/Gqp7Z+FC0FLvCAHJpmDczGBJBxYIs85TLKz731r2HXN1SkWq/YLH96UFx1ib4v0760jnPlhJDOTXtz4M/JvNzcjVutwJLRfHY8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137377; c=relaxed/simple;
	bh=p2kYrpN2VCeGqO/FofWoF5w2BwRgjrePpnIbZbRbi3c=;
	h=Date:To:From:Subject:Message-Id; b=Fpdeg9Q/iNMVh/FRWdbU1JagJwUKbX8N28Yxn1gxbgfDE5L8VyXxquiIRQ3cWwoB4jMnm5SMkPgfOW5mT90KKoLrDUSlgf5tCY5KulA4p/lsG7PaHocpyRI/YEnRNt7vcEGh5jh289G7w5AL7Xmko7ND/EZ/ATwF4mbTju1JJ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIIxIVXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIIxIVXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26DEC2BCB7;
	Mon, 18 May 2026 20:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779137376;
	bh=p2kYrpN2VCeGqO/FofWoF5w2BwRgjrePpnIbZbRbi3c=;
	h=Date:To:From:Subject:From;
	b=qIIxIVXZo/HccHe0SwbD/V6QxSTKFDgFF5AOhsTB7e5Iw0HosaZdKqsjeqU3gimcs
	 +0NRdgVj09K94sLUEBz1ezomx8mYls9zQJAY94rJWEP60yLX/e5rVFlgl5VtNv/+Q3
	 9eIDV4lppYZJ62sXJtTniJaQGpC4GkTh4pg+jmPM=
Date: Mon, 18 May 2026 13:49:36 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,kuba@kernel.org,konradybcio@kernel.org,jorge.ramirez@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-jorge-ramirez-ortiz-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20260518204936.A26DEC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Jorge Ramirez-Ortiz email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-jorge-ramirez-ortiz-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-jorge-ramirez-ortiz-email-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Subject: mailmap: update Jorge Ramirez-Ortiz email address
Date: Mon, 18 May 2026 11:10:05 +0200

Map old Linaro address to the new Qualcomm OSS address.

Link: https://lore.kernel.org/20260518091019.3926371-1-jorge.ramirez@oss.qualcomm.com
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-jorge-ramirez-ortiz-email-address
+++ a/.mailmap
@@ -434,6 +434,7 @@ John Stultz <johnstul@us.ibm.com>
 Jonas Gorski <jonas.gorski@gmail.com> <jogo@openwrt.org>
 Jonathan Cameron <jic23@kernel.org> <jonathan.cameron@huawei.com>
 Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
+Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com> <jorge.ramirez-ortiz@linaro.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from jorge.ramirez@oss.qualcomm.com are

mailmap-update-jorge-ramirez-ortiz-email-address.patch

