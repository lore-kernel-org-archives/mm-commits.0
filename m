Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980522;
	b=vCr2NHh5XnrCCXMqBKykRMhG4YM/paz08Hc3ltYDnxPo3R0iYzwA0l5OoSksY47lIqxA
	 STgXIrih4fGcFzHp4ofR0zZw/bodXg1G+mJTfMCtWhpmai4081BeesBtmztlBZIF/BamO
	 s1SfgYTgEl0CHydbGuf7plGwUv8E4WffrLKTIKBiyOli59lq3VKKxd+/eqj+i1NDgdbt1
	 mZ1dD2MNb83W2+8ZOM1PJ7OqHfNJjU/1JuvNTfbKSdxVmrKLSNhG3ct1mc94DWjyBLbo8
	 YlbDfCbPa+RG/eL6qe/HWrJTqldmS4MNSpGyCEXQaoRVVJIN7mE11lMw77ZlpbPbKRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980522;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5l+K2kxUdwI2CqHW3rK4BvCy1L/E8opsU/eLl1ovAUY=;
	b=rjXh5+8xjIdCOZMbzTVECA7MCFQD3ikpYZA/1TTDdSEVZ+loApTW2Q1uB9W4u2iaCAcM
	 Thj1zEk+GNlR5RFB3ua++yncf1GpM3iDZ/x63kpk52MIH/gN6fsstlZXD+99jWurwjXw+
	 1C+DOufFsFUeByI1NRKmu6ahr02+u6nfi+/eYUadCNGnQ72m6OlIq0jpKN5Irt7s2N+UF
	 zD9kbKkh/dGeuuky/pyrpd1IxHRGNkQx/XW5qdRt9xZzx0ZFMYGGQRw0sqt/IXgM3f/fE
	 4dwngOQ4OofSRsAmXPoThFZAlO6R4Gogz3KQcxeXp83IVh6pA6VCYrWfqR1x6OwUktg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MM71V1m3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B7C606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MM71V1m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AEB1F0281D;
	Wed, 18 Nov 2026 05:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980521;
	bh=5l+K2kxUdwI2CqHW3rK4BvCy1L/E8opsU/eLl1ovAUY=;
	h=Date:To:From:Subject;
	b=MM71V1m3tPYPC223eCj6w5/nWb26+9IgcFCwyfgsB6wYbA0Dv2AIpsc6ULMPBvgQF
	 /2qk+nIpQSb644VsB7CWH/Wrd1H7DNUdHvPKJBiBOWOk+1DGPSPRM3z/hqFeZDF7Mj
	 ak2+iADum+eQpn802V8zY+8oDexnby11wAA2HeeU=
Date: Tue, 17 Nov 2026 21:42:01 -0800
To: mm-commits@vger.kernel.org,beat@softbase.tech,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-entry-for-beat-m-liechti.patch removed from -mm tree
Message-Id: <20261118054201.81AEB1F0281D@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add entry for Beat M. Liechti
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-beat-m-liechti.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Beat M. Liechti" <beat@softbase.tech>
Subject: mailmap: add entry for Beat M. Liechti
Date: Sun,  1 Nov 2026 13:37:29 +0100

Map my old address, used for the firedtv fixes in 2009, to my current
one.

Link: https://lore.kernel.org/20261101123733.10578-1-beat@softbase.tech
Signed-off-by: Beat M. Liechti <beat@softbase.tech>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-beat-m-liechti
+++ a/.mailmap
@@ -154,6 +154,7 @@ Bart Van Assche <bvanassche@acm.org> <ba
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Bartosz Golaszewski <brgl@kernel.org> <bartosz.golaszewski@linaro.org>
 Bartosz Golaszewski <brgl@kernel.org> <bgolaszewski@baylibre.com>
+Beat M. Liechti <beat@softbase.tech> <bml303@gmail.com>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
_

Patches currently in -mm which might be from beat@softbase.tech are


