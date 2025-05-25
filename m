Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3811FC1D
	for <mm-commits@vger.kernel.org>; Sun, 25 May 2025 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159674; cv=none; b=HaPWtv41jwgkuMy209IsWaVxxphhwQJrnBBVBefRkroRh2F8yM1otYy+LZ7lg22M3LjL20gmv0MwwAlW1Me18L6h6AhXhYIK094Ur4PIplrvqNTWvmHuxNTWdQ++AqxRnshy9KiUo5fcRWhfU8Zjm8Zrs6KPtp9xcqjqANmnc9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159674; c=relaxed/simple;
	bh=hlCHP2qCKM5iLjBmoOLSnzu1AL9HJodfk+saEy/C3hk=;
	h=Date:To:From:Subject:Message-Id; b=rqd49zl/yyV2opxr0NE1N0y0TRoHOalK5jVGCO1g12cW2NO9S4q7bRBgHNR4nUgzwDKHwTCm7UiqETjhWA/y9/KA7VTUsVxftTon2jf0XX+TSILp3BsUA800N53l7Epax65vYhlNLOsnXjCmb4hPhBYS8FrnrYJrrOP+v5ibYsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KD9A++5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KD9A++5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E53FC4CEEA;
	Sun, 25 May 2025 07:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159673;
	bh=hlCHP2qCKM5iLjBmoOLSnzu1AL9HJodfk+saEy/C3hk=;
	h=Date:To:From:Subject:From;
	b=KD9A++5hsYJVkdLrgvIzhvkiAacfBaVBcW1K+Lfhx79iujo7RpJ8aVJToAKQMQxbk
	 SR+x3fmHtyjOb+Vrwm2kpwN2q/MWKwzgdVst1UBGECo24HEAMwW0VZq2qRiL9baUaX
	 LSVQuf1B5xjoC8LqFKv2GhwnQ4vlS0rdgQQdEkmY=
Date: Sun, 25 May 2025 00:54:32 -0700
To: mm-commits@vger.kernel.org,sw@simonwunderlich.de,kees@kernel.org,carlos.bilbao@kernel.org,antonio@openvpn.net,alexander.sverdlin@gmail.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-employer-email-address.patch removed from -mm tree
Message-Id: <20250525075433.6E53FC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add Jarkko's employer email address
has been removed from the -mm tree.  Its filename was
     mailmap-add-employer-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: add Jarkko's employer email address
Date: Fri, 23 May 2025 15:11:04 +0300

Add the current employer email address to mailmap.

Link: https://lkml.kernel.org/r/20250523121105.15850-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc: Antonio Quartulli <antonio@openvpn.net>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-employer-email-address
+++ a/.mailmap
@@ -312,6 +312,7 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@opinsys.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are


