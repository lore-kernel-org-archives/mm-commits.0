Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C5414B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908571; cv=none; b=N4Hj9HpULjNvjFjJSy9juKk/ZJQcTKYSMQVzZzDd9elfIGA8xDgy9JBt9XvOYZrtTvkSVkxq2dR87YJv8M1hiTTS8vL0aNyAgUFPlASRhvjPXi5xxS6UxsTgK6v4inpW6SDOvfwW7HVscq3b89LyYN1nSdcOaJo3qIcQVH4zfZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908571; c=relaxed/simple;
	bh=gwI4e8FOQ9+CBAiiqaqipWC6IE7YvvZBwp/tMRe0Fi0=;
	h=Date:To:From:Subject:Message-Id; b=MWo5H0uokSHQ01u5WlaW6/jVCp+G/p540GU6XNnoYoTdhJXsztaGcfEPBVWoFgcEA9V2zIvejOLoA0WZdpT1AenyWmD6kd8zrFnEJSsdst4xzctxxl+TQb37jzN8EP7v+wrLjIMgc0oj5HFJ+vUD09dQWDiNqoMSNg2JURqBi3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Xp2KWKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Xp2KWKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C8DC4CEFB;
	Wed, 12 Nov 2025 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908571;
	bh=gwI4e8FOQ9+CBAiiqaqipWC6IE7YvvZBwp/tMRe0Fi0=;
	h=Date:To:From:Subject:From;
	b=2Xp2KWKFRi1nUj7n4D3k1c2qLbdrZnKKg+x+0f/s95RnceWsdL6hSak0/spnf5aTC
	 3pid8Od+1y1ouc4bAcW5XLIbLnzG0VOTb4VYwzRjLpcXuVPDtUez/IVMwP3VBVnHiR
	 0ICrO1cMUUwS4dqAEzeB/7y1TZsUB+Y8KRifs9kw=
Date: Tue, 11 Nov 2025 16:49:30 -0800
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-name-and-email-addresses.patch removed from -mm tree
Message-Id: <20251112004931.23C8DC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update name and email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-update-name-and-email-addresses.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kepplinger-Novaković <martink@posteo.de>
Subject: mailmap: update name and email addresses
Date: Sat, 11 Oct 2025 15:59:39 +0000

Apply my new surname, remove unused and update to currently used email
addresses.

Link: https://lkml.kernel.org/r/20251011155903.7442-1-martink@posteo.de
Signed-off-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/.mailmap~mailmap-update-name-and-email-addresses
+++ a/.mailmap
@@ -496,9 +496,7 @@ Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
 Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
+Martin Kepplinger-Novakovic <martink@posteo.de> <martin.kepplinger-novakovic@ginzinger.com>
 Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
 Mathieu Othacehe <othacehe@gnu.org> <m.othacehe@gmail.com>
 Mat Martineau <martineau@kernel.org> <mathew.j.martineau@linux.intel.com>
_

Patches currently in -mm which might be from martink@posteo.de are


