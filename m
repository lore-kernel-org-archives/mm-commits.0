Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29045221FCD
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766341232; cv=none; b=p8n+pZQfhCAb7HSxMOu0gkJCNqT4XKo70BInk88Qt+s17fQHcD1VLn1Eu5PgOXzNquuwfJXLqcNOzCN/RlLZgwMhmPK5zlJiBoVv1ZOSGz3uus/cJ7Oi1a+WSJnkrJa4WWUDj+MV5jfhsf7J9168ZGzRDwldLRuW8IsvAuh/Mko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766341232; c=relaxed/simple;
	bh=UiTd2o/p1BG+Nd2HosZ+/YucDr4iUXFCO2okeHaS3II=;
	h=Date:To:From:Subject:Message-Id; b=LlZwoRUfjX3Khno/DgwGTzr5sh389pDRMYMc48/vuEykg4veKIp6M5ByaNe7niSlgWsGNVJpkAEgm+InxHY9LfsXlhjKAepUSCzKLyzExcxd+J7R2R7P8k3IjJjw4Rrih29IUajiCKHOHrCWvNCb0C5oTkKJXA+KJUK8XWPeDRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=by684lo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="by684lo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FB7C4CEFB;
	Sun, 21 Dec 2025 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766341231;
	bh=UiTd2o/p1BG+Nd2HosZ+/YucDr4iUXFCO2okeHaS3II=;
	h=Date:To:From:Subject:From;
	b=by684lo7TzEXKxQwMaP0AESB1IlQf/PLvl1bOUJnIBVzTgYxjH+QETxxn6fSUdxD8
	 +CCFGgZ2yU5qD8uDizUUt1fVzKC0Lge7swZGUyHD6dShMjc9yRCTiaqtc8APIvUlyy
	 kJ/ch1htN0U3NEcUh69quAgrT+8vpbUEB85SfAUs=
Date: Sun, 21 Dec 2025 10:20:30 -0800
To: mm-commits@vger.kernel.org,swilczek.lx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-szymon-wilczek.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221182031.41FB7C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Szymon Wilczek
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-szymon-wilczek.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-szymon-wilczek.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -787,6 +787,7 @@ Sven Eckelmann <sven@narfation.org> <sve
 Sven Eckelmann <sven@narfation.org> <sven.eckelmann@openmesh.com>
 Sven Eckelmann <sven@narfation.org> <sven@open-mesh.com>
 Sven Peter <sven@kernel.org> <sven@svenpeter.dev>
+Szymon Wilczek <swilczek.lx@gmail.com> <szymonwilczek@gmx.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
 Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
_

Patches currently in -mm which might be from swilczek.lx@gmail.com are

mailmap-update-email-address-for-szymon-wilczek.patch

