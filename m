Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068105;
	b=jrwwEJVAYE9sdSfzv/Hj/AqNNBW1HbuhwxKyWKJRZ6H/zhmwOA7WebQcfNpQspN/RDBj
	 n5hrimo+VgfmCGq1JUBqNda7QQHYV8ByceojZz+DCjdrgKFYTDqyD4+KkITvYP8lQGOIu
	 Q9FWtWhaxGfLQO/PGlHx2qmXaUwJWdkKlo9MlACZuXg3dojd7dQSmGXD2z7ExaONp1sn/
	 La/g6bGLN6B0t0l3e+TlnE6iziRVzYzVJ4a1g9fbf4wVPJC0uxccfW9FR6sA9yfr4fxKV
	 LoY7nUpczDk8y6WU2y718MYsrzIgFiOulSCGo/EgRZ//PeasrvY6O5hf/6K4iASC59A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068105;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=NHS/7u0zGn7J+fuK73824+S8M37KmlYyZkltGTYyIj0=;
	b=UJBc/f4cc6EFCjYgAbHz4oQic/0kreJx8jyivnykGKDSaZWBS/vkIvzR+dWmqpy1rqiJ
	 gpyYv3x8YG17QtKRUUAPfjQWlJk54413hAoXEt4IZA5Unzluxg0Vg9EIo0bZTdT463wcs
	 jA+d85qWA2vN3NFgLVjVqcCfzRYRJyajUIqEIkNaVa403kSA6pRYJRbFF1K45XyZBQfwW
	 MUH7ew14wm6W5/T1KSLq2QhAmAvE9W0z3timyvoo5R0Yoz7qczVMBJOSAhD9ZI5dZx9st
	 Mv1uUn8MKOMEV1M9A299Id791Je9bRC4V1ksqt9ECob7pTY/Nej/fnOIUPliduJNVvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qU+SxfiC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C0C606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qU+SxfiC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D126C1F000C4;
	Thu, 19 Nov 2026 06:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795068104;
	bh=NHS/7u0zGn7J+fuK73824+S8M37KmlYyZkltGTYyIj0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=qU+SxfiCGdXOQWk8uA6BdO8DdKK3ABoVrs+ZNNddEDz4xc7/Ngx5s2PkOik1Ih37q
	 4MFqQ8fnEc7cM0R4KAlQC3LXBhNybZz8kg+BxLlGTj9b8dYiEUzFnrCL+PXJMqZbgK
	 9BDax86D2GAxdbPWfzZYXRyD5F6oDoTGC6watmGI=
Date: Wed, 18 Nov 2026 22:01:44 -0800
To: mm-commits@vger.kernel.org,radhey.shyam.pandey@amd.com,
	michal.simek@amd.com,jeff.johnson@oss.qualcomm.com,tushar.nimkar@amd.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118-mailmap-update-v1-1-b7197cd9d19e@amd.com>
References: <20261118-mailmap-update-v1-1-b7197cd9d19e@amd.com>
Subject: + mailmap-update-email-address-for-tushar-nimkar.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261119060144.D126C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: .mailmap: update email address for Tushar Nimkar
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-tushar-nimkar.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-tushar-nimkar.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Tushar Nimkar <tushar.nimkar@amd.com>
Subject: .mailmap: update email address for Tushar Nimkar
Date: Wed, 18 Nov 2026 15:43:40 +0530

Map my old Qualcomm email address to my current AMD email address.

Link: https://patch.msgid.link/20261118-mailmap-update-v1-1-b7197cd9d19e@amd.com
Signed-off-by: Tushar Nimkar <tushar.nimkar@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Michal Simek <michal.simek@amd.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-tushar-nimkar
+++ a/.mailmap
@@ -974,6 +974,7 @@ TripleX Chung <xxx.phy@gmail.com> <tripl
 TripleX Chung <xxx.phy@gmail.com> <zhongyu@18mail.cn>
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
 Tudor Ambarus <tudor.ambarus@linaro.org> <tudor.ambarus@microchip.com>
+Tushar Nimkar <tushar.nimkar@amd.com> <quic_tnimkar@quicinc.com>
 Tvrtko Ursulin <tursulin@ursulin.net> <tvrtko.ursulin@intel.com>
 Tvrtko Ursulin <tursulin@ursulin.net> <tvrtko.ursulin@linux.intel.com>
 Tvrtko Ursulin <tursulin@ursulin.net> <tvrtko.ursulin@sophos.com>
_

Patches currently in -mm which might be from tushar.nimkar@amd.com are

mailmap-update-email-address-for-tushar-nimkar.patch

