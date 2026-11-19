Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062138;
	b=exiQam0dW/2MUu7KLm1T9lCnZ4U0nsbd7VC9TSwY12O9ZR+QJFmFI2IXU0KvQyUMuvD3
	 GtD4SLFdmUdu+efsjrpqIxCJl6+0SvHEKSOUNd5H0jTdciv/x6EdmNwe174r4fhANV1pR
	 8N4q7k8r0MiIu9qvlRoIOOu1lKdbMKg32z9kv4/RzpXnPPtAuMHc0rWIWmxvk3e9Ahx1H
	 AFIeC03ZaHS/UtkEebN8oSFwJ6shxO7HeZDQEaWrX2Vuf9fF1QXZwF8QJo7KQDhvC/cw/
	 P8neN3rE8BzioObdqyurWFLJ4Fkp1pA7oBvHwy0jQIqycyNht4ef0sog8ugHXFf9O0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062138;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OEbopEnBfcACBcm5cXRW2OQ20IdSJWT+Utdj1k1zKy8=;
	b=C95JxxDS0MavxG4RroqM8mAF0o/FlrTcxuHYSmWG1CCMXz3eYvB667ZJqRoLyVPh9UKI
	 dHx8Z8LWgvaRrZQroe133N8LYyhH8T+8MgiOIwZkll1wt7GFF0caRaoC00DDcHeBoLK03
	 XffQ6Fy/b3JGFnfifCrBJrnNPVopDhvBAeA6o3Ekfqj5xZ+uuZNunUw923GY9Ei1vwmGr
	 bVbCuuM9kuNmWh5+b/kgxM81W0N+HAzwaELLjBHE9rg9740TAAv7oF+WXyaUyvIw+yT0M
	 e4iu1VAKXpRlRJ8beJLKsDtVOqzzAcAcsJ8LRiFwrIYExwSurSMWur4YeMA/fdWK5ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Rkkrd9Y5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AB3606A325
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 04:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Rkkrd9Y5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B431C1F000C4;
	Thu, 19 Nov 2026 04:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795062137;
	bh=OEbopEnBfcACBcm5cXRW2OQ20IdSJWT+Utdj1k1zKy8=;
	h=Date:To:From:Subject;
	b=Rkkrd9Y5LKk3JkXYpQS8HTM2CXhZSx2OV9hiwyGJ0+8kIPvvUbRfWRjxe9sE73GoE
	 eZP98ziGtj1e7iaT1MRX0sacG9F97HsszAKF4P/zhq7J1gymOVA4QzMdfR44ORXUo9
	 q7jHzKuzmRx9jVkFuI56ybwvGu6mEFlHoFD9x6/I=
Date: Wed, 18 Nov 2026 20:22:17 -0800
To: mm-commits@vger.kernel.org,kuba@kernel.org,jeff.johnson@oss.qualcomm.com,
	cel@kernel.org,alex@sverdlin.org,mukesh.savaliya@oss.qualcomm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-mukesh-savaliya.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261119042217.B431C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: .mailmap: update email address for Mukesh Savaliya
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-mukesh-savaliya.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-mukesh-savaliya.patch

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
From: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Subject: .mailmap: update email address for Mukesh Savaliya
Date: Wed, 18 Nov 2026 18:31:50 +0530

Map my old Qualcomm email addresses to my current oss.qualcomm.com address.

Link: https://lore.kernel.org/20261118130150.2877850-1-mukesh.savaliya@oss.qualcomm.com
Signed-off-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-mukesh-savaliya
+++ a/.mailmap
@@ -697,6 +697,8 @@ Morten Welinder <welinder@darter.rentec.
 Morten Welinder <welinder@troll.com>
 Muhammad Usama Anjum <usama.anjum@arm.com> <usama.anjum@collabora.com>
 Mukesh Ojha <quic_mojha@quicinc.com> <mojha@codeaurora.org>
+Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com> <msavaliy@codeaurora.org>
+Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com> <quic_msavaliy@quicinc.com>
 Muna Sinada <quic_msinada@quicinc.com> <msinada@codeaurora.org>
 Murali Nalajala <quic_mnalajal@quicinc.com> <mnalajal@codeaurora.org>
 Mythri P K <mythripk@ti.com>
_

Patches currently in -mm which might be from mukesh.savaliya@oss.qualcomm.com are

mailmap-update-email-address-for-mukesh-savaliya.patch

