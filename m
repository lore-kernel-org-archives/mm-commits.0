Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A1535AC2D
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837559; cv=none; b=pdD4qYa0g535de8+9XTypUdo4FOvH0QIfbPBwEM2RX2CkEBwb++9ZLuMqn49N+nt+iHn+L8xUPXLOj93jyDFx55AkEAJ1zpdJQvQJQ6UVGOPGPqtz3SdkvKkUi15Q7a5tNcc3znHdYIwwaXSyTI27vjumRTGWUz/gALdtp/jDMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837559; c=relaxed/simple;
	bh=AYHCYeTInoe0VCHrX/+eiHzQ6RvXMv4UpWAV4WYBpAI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rdVtBVolDQIFhGLylDY8Sqgtnyvqi3rK33b/CHhwOmHjB9BSMoXEwyipk9n/sTg7l77MMsEl8QFN5tNOGVbs7k1Pj0Z9r8PGEgEQQhLCF1Ml/3XQfcLSTAMMOpKSqyDPat2hAt/edVUQb2noNclWRGLOxJdophngAmUZvznn9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snbXLKvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snbXLKvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2464DC4CEF7;
	Fri,  6 Mar 2026 22:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837559;
	bh=AYHCYeTInoe0VCHrX/+eiHzQ6RvXMv4UpWAV4WYBpAI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=snbXLKvzy537x7FhXd6yDEHpjgSqBGb+8YVudG4iprPPSqQzjftzMSNyQxh6P78fp
	 2l9HxTcXCacFYphydcY3u884/O+2/UtuqbGGU4CBBFJBxDKwBCO6BKdx6w6DpkHJYL
	 Mk+xUdh5F2SV1V/c+OUAiLdXJ8yEqm780zT9escM=
Date: Fri, 6 Mar 2026 14:52:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kek ma <hlcj1234567@gmail.com>
Cc: mm-commits@vger.kernel.org, liam.howlett@oracle.com,
 andrewjballance@gmail.com, aliceryhl@google.com, techyguyperplexable
 <objecting@objecting.org>
Subject: Re: +
 lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch added to
 mm-new branch
Message-Id: <20260306145238.e39787f9a09b68a82af7bfa7@linux-foundation.org>
In-Reply-To: <CAHgTTC+i_wUady+CQkkHf+BaQhGcjA21Qrxp8a+UXqvtvp8dAA@mail.gmail.com>
References: <20260306213342.D7C02C4CEF7@smtp.kernel.org>
	<CAHgTTC+i_wUady+CQkkHf+BaQhGcjA21Qrxp8a+UXqvtvp8dAA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 6 Mar 2026 21:36:11 +0000 kek ma <hlcj1234567@gmail.com> wrote:

> Hello, I'm using Gmail because this is very important
> 
> What needs to be improved to make it merge to linux-next?
> 
> It says in your email it won't be merged to next
> 

OK, I enhanced the message:


  The mm-new branch of mm.git is not included in linux-next
+
+ If a few days of testing in mm-new is successful, the patch will me moved
+ into mm.git's mm-unstable branch, which is included in linux-next


