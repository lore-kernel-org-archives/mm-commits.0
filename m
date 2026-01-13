Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0B02DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280963; cv=none; b=SgXlSTBBfjW82FqixyPtj0PvsNbb0sHh+tjVGDbilkAxS4b2Cap7gxPku4g0CdB6PKhtlxYpTeTt4pc1NhPxtRG91UD5MIYL2TSA475e/4zJjeqWbjjWJdSaAEotDQTeqoUpjQNk3bPrtgSGZ8sm6JRmxSDNlhzJjGC8oGrQFas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280963; c=relaxed/simple;
	bh=RaOWW448KM7otMSDuIJiJDvWyQWWOKup3DEyOdwoPsU=;
	h=Date:To:From:Subject:Message-Id; b=FDGjcqxG5RmwtOnKO3cX0sAqL0UhxVeJTAx5eRSMQOBfOkcJmfphGVv7K7T1ZNYhZV1l6qh/rHepL+w15NTdqSvAA5uSZwinXCC0oG72P22Vkh2zlilMpPusedydIsTpg8Y2us5l7i638upXw5z4xBVH/6AZtUschr1h0CcFlKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNOCzoCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNOCzoCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2530C116C6;
	Tue, 13 Jan 2026 05:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280962;
	bh=RaOWW448KM7otMSDuIJiJDvWyQWWOKup3DEyOdwoPsU=;
	h=Date:To:From:Subject:From;
	b=lNOCzoCcOgVmJq5RYng9eng9q8echnQLC5UBtZsXctzFQrU0Wa7VTBxz36ChQ3sDC
	 GsWjSfW4JpQnbDEVDwxycLWfaS9nQCvWZSm/Cm2RNi6s0PVQZFJDyEpFcOu0CWrlyo
	 8vRxtkQkCjrYE5C5ggFW/nFU9TvprevLc6pusqgw=
Date: Mon, 12 Jan 2026 21:09:22 -0800
To: mm-commits@vger.kernel.org,swilczek.lx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-address-for-szymon-wilczek.patch removed from -mm tree
Message-Id: <20260113050922.C2530C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Szymon Wilczek
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-szymon-wilczek.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Szymon Wilczek <swilczek.lx@gmail.com>
Subject: mailmap: update email address for Szymon Wilczek
Date: Sun, 21 Dec 2025 16:17:10 +0100

Map my old address <szymonwilczek@gmx.com> to my new address
<swilczek.lx@gmail.com>.  The old account is no longer accessible due to
provider blocking access.

Link: https://lkml.kernel.org/r/20251221151710.13747-1-swilczek.lx@gmail.com
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-szymon-wilczek
+++ a/.mailmap
@@ -794,6 +794,7 @@ Sven Eckelmann <sven@narfation.org> <sve
 Sven Eckelmann <sven@narfation.org> <sven.eckelmann@openmesh.com>
 Sven Eckelmann <sven@narfation.org> <sven@open-mesh.com>
 Sven Peter <sven@kernel.org> <sven@svenpeter.dev>
+Szymon Wilczek <swilczek.lx@gmail.com> <szymonwilczek@gmx.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
 Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
_

Patches currently in -mm which might be from swilczek.lx@gmail.com are

ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

