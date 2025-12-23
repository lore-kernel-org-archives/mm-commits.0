Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFCA2E975E
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517837; cv=none; b=MdhK/IRp00onekDn15ksMcZQqSLPt0gyO2bYseJObsLrzgyWiOPD6bRZN/XOCToV720qOpoO/QuFyJMBXARpzJX4RbHsWkSGRlQOV9tSmgU+cLzCFIyaEsEbGPir/tDaBDm2gtXs4BIUGIAj9tj6azuYmCg1ZZibPhEYw7cQXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517837; c=relaxed/simple;
	bh=qeDlQVYK3zRMzDQEsS/tI1bz+GDPfKg4bgMww4JgYkE=;
	h=Date:To:From:Subject:Message-Id; b=TEfoGDxHQMJuJN4K7f954JMXf8kbizCJceM7g13x03fv5DpltmNLtMHGs+zLVUTsBcYDuP2kEfixTcii+d8z6RvS5uMhWS7bo69ObwaDZZ7RFxBwos3YfcXEgfnQ1LEVv+FDXPU6y8u0lbBPhU9tWiH/fxNdcBsElbEV+1nMnHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MgJHphRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MgJHphRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67534C113D0;
	Tue, 23 Dec 2025 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517836;
	bh=qeDlQVYK3zRMzDQEsS/tI1bz+GDPfKg4bgMww4JgYkE=;
	h=Date:To:From:Subject:From;
	b=MgJHphReNw2UGyqKlTb4RXK/FZ6rhrV1nKlEz9MHOsZbqHwdii9/MCo8jGBuxxyyy
	 0SLpBjOpN7BRHgexw1i8d5B8xpgEL126RhGTTUHlmXIa9S7f+PbhxqEySZmIfHLcdC
	 Zi59w3df/TSGIbdJSd0yPFVy+/4HbMqw51qNA4mQ=
Date: Tue, 23 Dec 2025 11:23:55 -0800
To: mm-commits@vger.kernel.org,hverkuil@kernel.org,brgl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-bartosz-golaszewski.patch removed from -mm tree
Message-Id: <20251223192356.67534C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Bartosz Golaszewski
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-bartosz-golaszewski.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bartosz Golaszewski <brgl@kernel.org>
Subject: mailmap: update entry for Bartosz Golaszewski
Date: Fri, 28 Nov 2025 14:33:18 +0100

My linaro address will stop working tonight. Update my mailmap entry.

Link: https://lkml.kernel.org/r/20251128133318.44912-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <brgl@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-bartosz-golaszewski
+++ a/.mailmap
@@ -127,7 +127,8 @@ Barry Song <baohua@kernel.org> <Baohua.S
 Barry Song <baohua@kernel.org> <barry.song@analog.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
-Bartosz Golaszewski <brgl@bgdev.pl> <bgolaszewski@baylibre.com>
+Bartosz Golaszewski <brgl@kernel.org> <bartosz.golaszewski@linaro.org>
+Bartosz Golaszewski <brgl@kernel.org> <bgolaszewski@baylibre.com>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
_

Patches currently in -mm which might be from brgl@kernel.org are


