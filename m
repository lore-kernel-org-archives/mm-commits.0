Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964362D838A
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164809; cv=none; b=mSOPAb+86tPNhrjOevD4cxXIp8l7RrrAA8G1IKrB3Fi79/151euowzAVJwp4wlHWU35Neql+Y3wGxNkn+JGrU/yIhoF1GEQvBqES/jM4uIDDuBWVfUkn8NhHsNMmJISIvU72HxUuM9UaajNEuDptlx32MY0JnD9LC5X7zNRTxdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164809; c=relaxed/simple;
	bh=ASiAwau8oUKkUZOqbBdkehP/UJu61/Le9wj/c8BWe0g=;
	h=Date:To:From:Subject:Message-Id; b=hgHjUS9Oo232VAE44Oxbt/Plr8AlU4hIFBG0xLGwstDYwerI0xlptUZRLLVBbi7LkKCDeI99nlIIBVL4Th6do0YCRqPquD5+xwQv5Z7t/7NvzCQe9/JsWxwE1hd6VWv6zRGFBojmyT3L64A/0e+q2gpF1flFBcEmBpXsAXI9YFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PIJU7ApD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PIJU7ApD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15204C19423;
	Tue, 10 Mar 2026 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773164809;
	bh=ASiAwau8oUKkUZOqbBdkehP/UJu61/Le9wj/c8BWe0g=;
	h=Date:To:From:Subject:From;
	b=PIJU7ApDGibRU9G4oAz9327k7fuNx7WoDvptdCxrfSUj12XFSSXfAsTXQXpuFqXUZ
	 liiJOzs3/iCQqziqc5zg0NfzHip9J/QD7il+7sqtLW0j5U4tnkjFe2XkxSJus40Z6M
	 7EDXB25oQKZft3qnWYYj6v0eWXNbsTLIUDMKetKo=
Date: Tue, 10 Mar 2026 10:46:48 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,kuba@kernel.org,hverkuil@kernel.org,carlos.bilbao@kernel.org,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-muhammad-usama-anjum.patch added to mm-hotfixes-unstable branch
Message-Id: <20260310174649.15204C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Muhammad Usama Anjum
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-muhammad-usama-anjum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-muhammad-usama-anjum.patch

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: mailmap: update email address for Muhammad Usama Anjum
Date: Tue, 10 Mar 2026 17:17:39 +0000

Add updated email address.

Link: https://lkml.kernel.org/r/20260310171757.3970390-1-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-muhammad-usama-anjum
+++ a/.mailmap
@@ -580,6 +580,7 @@ Morten Welinder <terra@gnome.org>
 Morten Welinder <welinder@anemone.rentec.com>
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
+Muhammad Usama Anjum <usama.anjum@arm.com> <usama.anjum@collabora.com>
 Mukesh Ojha <quic_mojha@quicinc.com> <mojha@codeaurora.org>
 Muna Sinada <quic_msinada@quicinc.com> <msinada@codeaurora.org>
 Murali Nalajala <quic_mnalajal@quicinc.com> <mnalajal@codeaurora.org>
_

Patches currently in -mm which might be from usama.anjum@arm.com are

mailmap-update-email-address-for-muhammad-usama-anjum.patch

