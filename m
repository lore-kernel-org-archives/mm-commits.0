Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCB3570A6
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676280; cv=none; b=EaeF7Coeco8MFyZ7JvtZaYcY0qlbVHWtWCeP+zv6iuu2VJKDH9wCACnmeVeQ0rcF8SF0Kqq5dS7XJ8rJ+Ek5h2QA///NKc4Uyzuy5ANUpMvC+FI5zaU7UWxiL9JaWD/yQlc3QJ2MGmvNWSEyPJ1/8/CwWoGSSQOQRyXAljgqD1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676280; c=relaxed/simple;
	bh=w1V0pHxzGn8lMYbW70+7JKbNjSLZy4H/kunkj0i9IMk=;
	h=Date:To:From:Subject:Message-Id; b=CKvlqbSQ5eUc82IKrYV3L/T4bfKLNn/xPjo+HMMEmF2YZqvhVOokewR5Hdo3QiVWyir3OhSZ1Nd7CJfF+Xxj5x0djMMCU6wNeeeJg70oF07dnCaZ43HSzmcNLEeq2bZBd+AeW2PTyaL8GuXHp2Rjzyzze3qMeWgGtx4f7VB4EO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tutDAb/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tutDAb/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7649CC4CEF1;
	Thu, 20 Nov 2025 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676280;
	bh=w1V0pHxzGn8lMYbW70+7JKbNjSLZy4H/kunkj0i9IMk=;
	h=Date:To:From:Subject:From;
	b=tutDAb/juoUkuJIpmVa1Z9cFqc/oGdrb/xm+D5mX5DH7Cgb1OsgR00GYWVQrUMioN
	 UuYVRN/SdStm3bwXnGWpqwLFCfLJA1jREj9UW+Xg+rivewD5/qDPKzv+VqMFI3ZV8S
	 XtIwNZSGzxyU5CRAZ6BkfewxAALcEFZ5lk012MLY=
Date: Thu, 20 Nov 2025 14:04:39 -0800
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,gustavo@padovan.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-remove-myself-from-sync-framework.patch removed from -mm tree
Message-Id: <20251120220440.7649CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Gustavo from sync framework
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-sync-framework.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gustavo Padovan <gustavo@padovan.org>
Subject: MAINTAINERS: remove Gustavo from sync framework
Date: Wed, 12 Nov 2025 10:43:30 -0300

I haven't been involved in the work anymore for some time.  It is only
fair that I remove myself from it and let other continue to take care of
it.

Link: https://lkml.kernel.org/r/20251112134330.64130-1-gustavo.padovan@collabora.com
Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-sync-framework
+++ a/MAINTAINERS
@@ -24826,7 +24826,6 @@ F:	drivers/regulator/sy8106a-regulator.c
 
 SYNC FILE FRAMEWORK
 M:	Sumit Semwal <sumit.semwal@linaro.org>
-R:	Gustavo Padovan <gustavo@padovan.org>
 L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 S:	Maintained
_

Patches currently in -mm which might be from gustavo@padovan.org are


