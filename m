Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF718DF8D
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029457; cv=none; b=VPZ2JYxZ/nGXdKPzGbloG2FYpxd2EwRio0wLY24XxHGjHX8lIwQ3wzzgvgA8D1GOOGIrtLImZOODU0yGbSJHZfpVdONCb4N/k9bgAHuJcr2WPtYXRobd14VIz4ZkfsCImBMl/+pyJnkvBzfXSQHHQD4UGJ6a38keVBEbIPHuc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029457; c=relaxed/simple;
	bh=AV/UNATnD9kHaNaajRKq+84etnUNoavtOWbP374verE=;
	h=Date:To:From:Subject:Message-Id; b=aWEPfzlRiz5H2AlFXfHgKqMx+qVaPC4yxpus9URj53Ee7o6DUv4pXOQNdySGmU765Z+QFclIpPYqqiAI2xtPefXVmnxwsTOm+Uqy1QOJI+qe9OxXA7NWN0kR2jvCVHrsLzMOAvoqiLGMUshq89rn8Tj2Tg3GkLKlxLKfw0q+Syw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=04p8cE7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="04p8cE7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42CAC4CED2;
	Tue, 28 Jan 2025 01:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738029457;
	bh=AV/UNATnD9kHaNaajRKq+84etnUNoavtOWbP374verE=;
	h=Date:To:From:Subject:From;
	b=04p8cE7At+XSfEbjZsNnFJYFgxNtMzvNVdrZRenz1vnaKGfye4qAmPMbJX/JWPbtI
	 yotS5fn+A3ed/jByZrU5EPuOIKYrxlOHjroD0jwWwazLtPHo1V8sxtxxYw/qfiOz3Y
	 gIBvQY3G/rfo72W5Txg57L8x0BHBSYj8hRrqaEwA=
Date: Mon, 27 Jan 2025 17:57:36 -0800
To: mm-commits@vger.kernel.org,christopher.obbard@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-christopher-obbard.patch added to mm-hotfixes-unstable branch
Message-Id: <20250128015736.E42CAC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: update email address for Christopher Obbard
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-christopher-obbard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-christopher-obbard.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christopher Obbard <christopher.obbard@linaro.org>
Subject: .mailmap: update email address for Christopher Obbard
Date: Wed, 22 Jan 2025 12:04:27 +0000

Update my email address.

Link: https://lkml.kernel.org/r/20250122-wip-obbardc-update-email-v2-1-12bde6b79ad0@linaro.org
Signed-off-by: Christopher Obbard <christopher.obbard@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-christopher-obbard
+++ a/.mailmap
@@ -165,6 +165,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Brauner <brauner@kernel.org> <christian.brauner@ubuntu.com>
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
+Christopher Obbard <christopher.obbard@linaro.org> <chris.obbard@collabora.com>
 Christoph Hellwig <hch@lst.de>
 Chuck Lever <chuck.lever@oracle.com> <cel@kernel.org>
 Chuck Lever <chuck.lever@oracle.com> <cel@netapp.com>
_

Patches currently in -mm which might be from christopher.obbard@linaro.org are

mailmap-update-email-address-for-christopher-obbard.patch

