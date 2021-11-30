Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84A8C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 30 Nov 2021 21:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhK3Vzo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 16:55:44 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:46757 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbhK3VzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 16:55:11 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J3bXQ2lLYz4xPv;
        Wed,  1 Dec 2021 08:51:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638309110;
        bh=2wtX1KuL7qa18qACj2lF6yIursAILvJZ8znYoVDtrR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VF0po0MU3IvClBiAQoJ0OBvJWMti7Aj2EbW6ufJ84INiBQN1hjzyN+gFk60eoqrqc
         0irXiCZC9hp+KlGrjd+iyK/X42fklqt21vNdspbiSqd8gUvccNnsjrYFwHr78pXqvZ
         fPb8xn8njDa4dca18WKT48UcAim0sz5F71vYOl8GnONDqkbv3ba7kT/jt5X+tnSmZ4
         glrtgXWNlrPD5HelukOFqz/c+/JMZz4x2L/9nImKkSLkuCFNTNh5Q8wNOXLHOFfanQ
         1/CM3rux9+K2aPXG5su61zTwTNkQB6fh3MpPXN0iqPV7FvnX+AVr+QFfWhC23uEVYb
         MhBNEvWghYlBQ==
Date:   Wed, 1 Dec 2021 08:51:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     lkp@intel.com, mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject: Re: +
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch added to
 -mm tree
Message-ID: <20211201085149.0ed87352@canb.auug.org.au>
In-Reply-To: <20211130210558.lvJNs8vTI%akpm@linux-foundation.org>
References: <20211130210558.lvJNs8vTI%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/twigOAlNGC1+FulY1op14/P";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/twigOAlNGC1+FulY1op14/P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 30 Nov 2021 13:05:58 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix
> has been added to the -mm tree.  Its filename is
>      firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/twigOAlNGC1+FulY1op14/P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGmnPUACgkQAVBC80lX
0Gxq9gf+OQPxtw+Rf4aN+We5AIIg/MXbqpUDO/DM4gfBVuYB8frYYIc3lpbjvbxF
Awy1nJoUR9X3Kwsw8ba6/1O/2nwm9g96BmGucvfwShCCa1Tv2c28eEJkgv8qDbps
ZOfqPvRs/5l7k5NPXDWCnDGyUxY9tWraGFMB2oblO3E2uB7xysZ6hmuJOMLpiP3i
yrEGGuHEkugROoe4ZV4k9az34I8xUQPMt5yZwRHTdwDlUo3UQgpjLPkRUOHAQYcr
b30VhMfhELrNlWXXzH2X7Y9wW/yAerDSupe3YTt6vSmxDrup8xOJ4TNYZd3Xv/1k
jmZ9eWGx98xZvGjzTr5M76wy7O/IPg==
=gbki
-----END PGP SIGNATURE-----

--Sig_/twigOAlNGC1+FulY1op14/P--
