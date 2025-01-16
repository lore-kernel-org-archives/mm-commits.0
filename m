Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E61E505
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004583; cv=none; b=QQH89CsLTLyJHobbP2N4iV8gVz5SemRMAfwz+4fV0WdIOgVxh3lbvs2+L3b0AaPUEs3wStjiHubuB+SS6IurHoY7uSskLUT/WFoPhz3gJ9ekWQN09K/s14Q6iV5RZUNEFnN+n9rO7g1AF1OJF6Ae4rSwdt76J00904NCJnlS4Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004583; c=relaxed/simple;
	bh=hLqy61HPwwFzJWf0UngHTRqtd7B2Zd3pPZh6SXCDcIw=;
	h=Date:To:From:Subject:Message-Id; b=Spm1fPCW4L16dGwwft6J7F+Yd/tLUss8AAjhXxpIo3sH8oBxDv+syU7mmcYyABn9kvunSgj4xKMVohooeOnx2wbsMI0sS/DhWGSR244h2w5n+ZmDAQTaFNmqm2MT0CJT9or/wXrOPJBJT6T1yttAycvYSv0uOljTEhz5hEoHUXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jy/VLqpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jy/VLqpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCB2C4CED6;
	Thu, 16 Jan 2025 05:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737004583;
	bh=hLqy61HPwwFzJWf0UngHTRqtd7B2Zd3pPZh6SXCDcIw=;
	h=Date:To:From:Subject:From;
	b=Jy/VLqpx11puoi0+6bkF4vyX4weeBKaszrRK7CWwQiC+eQX/3xK+uUqh6RyK7D9MY
	 8kQi5/5u2O8oy/qXpXMHiPEvVkjume5yyqlqXEXszXvG/hxFPHEBTEpNscBRF1lrUK
	 Y2IQJVcJAnF9ruPrTqjX4ifTiPsV3n/OpkJcPrOo=
Date: Wed, 15 Jan 2025 21:16:22 -0800
To: mm-commits@vger.kernel.org,ethan@ethancedwards.com,ethancarteredwards@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-ethan-carter-edwards.patch removed from -mm tree
Message-Id: <20250116051623.0DCB2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Ethan Carter Edwards
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-ethan-carter-edwards.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ethan Carter Edwards <ethancarteredwards@gmail.com>
Subject: mailmap: update entry for Ethan Carter Edwards
Date: Mon, 13 Jan 2025 11:22:22 -0500

Map old gmail + name to my current full name and email.

Link: https://lkml.kernel.org/r/xbfkmvmp4wyxrvlan57bjnul5icrwfyt67vnhhw2cyr5rzbnee@mfvihhd6s7l5
Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-ethan-carter-edwards
+++ a/.mailmap
@@ -200,6 +200,7 @@ Elliot Berman <quic_eberman@quicinc.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
+Ethan Carter Edwards <ethan@ethancedwards.com> Ethan Edwards <ethancarteredwards@gmail.com>
 Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@microchip.com>
 Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@collabora.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
_

Patches currently in -mm which might be from ethancarteredwards@gmail.com are


