Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437171;
	b=QwCaSJ5Fui02cro4KtzfXf5ze5OalgyTXGgWa8AQD/i4n9F39+amEbz/guCijbZ7fgtG
	 O7bebQB3PfsWcEgAQPviX71Y2unEpTWulex8BgzQe7fIQgetuaHfqSjmq/P/DaRL35gGO
	 BB7AaxjUHK5ejTzO9Kw2MHvSy3kQVZIPT6GcTmZl132QTxI828DOE7o5DIXygrYBtbJeF
	 KP4pRxeL1YBBuNOki0VAA9Q0hY3ocemDFZe5ztH5kN/feaSAayvBV54/z3WCe2EQKNu+j
	 qbqlrIEpYR+5isW4xmAEorbIwWMzMQE0QMptlxFX2PTpSe7lEziQVQ0GUEHPsiKrSkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437171;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X1qYJ6FJOmTsrUCLlgcpZdl9sP3/P7cgwO3NWeb608A=;
	b=QVEoZA/vboZVojZUWXduWDKJj8Aiemc9Y3ZhH9oFKVMqMX/B6dLujqPBtpqNAH8/hNWq
	 B9n2j+8/AzMwrH49gAVYC8fr/QF1xEfkPN3hGrA7SKUPDpYrptjTe4aNRt2Sbn2kcur1l
	 DtGZQ+9OhNiefbA1w1HSovIzjjAiDy5wWVwkP35Sj8XyWZh/L6VFxJTsfUlx4SpnsDtj4
	 0rTbFrL2ZjFxg/q+44KUJCvomRDji+vdKYFvbslSnnKVpqcNqFuKWIs6xvVfmQYH24XvM
	 mMq89KQPpcrNbnssCgnrw/EXDzZASec1f90DKo6aQ92dRQzmKEOU4jLuZ9sJlvCUZQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rZvsPdVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF038606C128
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 22:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rZvsPdVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA611F00A05;
	Wed, 11 Nov 2026 22:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794437171;
	bh=X1qYJ6FJOmTsrUCLlgcpZdl9sP3/P7cgwO3NWeb608A=;
	h=Date:To:From:Subject;
	b=rZvsPdVBGm2gaL/nog5VO4Ut83VARCROMbQLFF3mqLUFYfkchpiYFEdgvT0yjFSkd
	 VbucZG6KuZuwudscOrnf4u6okV1aXmhnVekhqSe3Z8C8gizLRS7NfBYczq/tpeaMME
	 q37BXee68YQVfWIc8PHKKqI9JbzPRhD7jhvYXvZ8=
Date: Wed, 11 Nov 2026 14:46:10 -0800
To: mm-commits@vger.kernel.org,yehezkelshb@gmail.com,lukas@wunner.de,
	andreas.noever@gmail.com,westeri@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-mika-westerbergs-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20261111224610.EDA611F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update Mika Westerberg's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-mika-westerbergs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-mika-westerbergs-email-address.patch

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
From: Mika Westerberg <westeri@kernel.org>
Subject: mailmap: update Mika Westerberg's email address
Date: Wed, 11 Nov 2026 13:39:09 +0100

My @linux.intel.com address will be going away soon so switch to use my
@kernel.org address.

Link: https://lore.kernel.org/20261111123910.1324579-1-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <westeri@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yehezkel Bernat <yehezkelshb@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Andreas Noever <andreas.noever@gmail.com>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-mika-westerbergs-email-address
+++ a/.mailmap
@@ -669,6 +669,7 @@ Michel Lespinasse <michel@lespinasse.org
 Michel Lespinasse <michel@lespinasse.org> <walken@zoy.org>
 Mickaël Salaün <mic@digikod.net> <mic@linux.microsoft.com>
 Miguel Ojeda <ojeda@kernel.org> <miguel.ojeda.sandonis@gmail.com>
+Mika Westerberg <westeri@kernel.org> <mika.westerberg@linux.intel.com>
 Mike Leach <mike.leach@arm.com> <mike.leach@linaro.org>
 Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
 Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
_

Patches currently in -mm which might be from westeri@kernel.org are

mailmap-update-mika-westerbergs-email-address.patch

